{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.auto-upgrade;
in
{
  # Strategy: "pull and rebuild":
  # 1. Pull: ExecStartPre updates the NixOS configuration repository with
  #    `git pull --ff-only` as the configured unprivileged user, allowing Git
  #    to use that user's credentials. The pull fails if the local branch has
  #    diverged from its upstream.
  #    This mechanism can also be extended to update additional private repos
  #    without the need to provide git credentials for the root user.
  # 2. Rebuild: The built-in nixos-upgrade service runs `nixos-rebuild boot`
  #    using the local flake path to the repository.
  options.features.auto-upgrade = {
    enable = lib.mkEnableOption "Automated NixOS upgrades from a local flake path";

    user = lib.mkOption {
      type = lib.types.str;
      example = "user";
      description = "Local user with SSH keys as git credentials";
    };

    flakePath = lib.mkOption {
      type = lib.types.str;
      example = "/home/user/git-project/nixos-config";
      description = "Absolute path to the local flake repository.";
    };

    dates = lib.mkOption {
      # https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html
      type = lib.types.str;
      default = "04:00";
      example = "weekly";
      description = ''
        How often or when the service is triggered, used for the systemd timer.
        The format is described in {manpage}`systemd.time(7)`.
        Note: This acts as a logical OR with the 'onBootDelay' option.
      '';
    };

    onBootDelay = lib.mkOption {
      # https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html
      type = lib.types.str;
      default = "-1";
      example = "5min";
      description = ''
        Add a fixed on-boot delay before each automatic system upgrade.
        The delay is useful to let the OS finish loading services.
        Set to '-1' to disable the option entirely.
        This value must be a time span in the format specified by
        {manpage}`systemd.time(7)`.
        Note: This acts as a logical OR with the 'dates' option.
      '';
    };

    randomizedDelaySec = lib.mkOption {
      # https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html
      type = lib.types.str;
      default = "3min";
      example = "5min";
      description = ''
        Add a randomized delay before each automatic system upgrade.
        The delay will be chosen between zero and this value.
        This value must be a time span in the format specified by
        {manpage}`systemd.time(7)`.
      '';
    };

    persistent = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = ''
        If set to true, the time when the service unit was last triggered
        is stored on disk. When the timer is activated, the service unit
        is triggered at least once during the time when the timer was
        inactive. Such triggering is nonetheless subject to the delay
        imposed by RandomizedDelaySec=. This is useful to catch up on
        missed runs of the service when the system was powered down.
      '';
    };
  };

  # https://wiki.nixos.org/wiki/Automatic_system_upgrades
  config = lib.mkIf cfg.enable {
    # Built-in NixOS auto-upgrade service
    system.autoUpgrade = {
      enable = true;
      # '--upgrade' updates Nix channels and has no effect on flake-based systems
      upgrade = lib.mkDefault false;
      flake = lib.mkDefault "git+file://${cfg.flakePath}#${config.networking.hostName}";
      operation = lib.mkDefault "boot";
      dates = lib.mkDefault cfg.dates;
      flags = [
        # Disallow `flake.lock` changes, updated pinned versions must arrive through Git
        "--no-update-lock-file"
        # Never persist a lock file generated during the rebuild process
        "--no-write-lock-file"
        # Include full build logs
        #"--print-build-logs"
      ];
      randomizedDelaySec = lib.mkDefault cfg.randomizedDelaySec;
      persistent = lib.mkDefault cfg.persistent;
    };

    # Extend the existing nixos-upgrade service
    systemd.services.nixos-upgrade = {
      # Ensure network is available before starting the service (including prerequisites)
      # https://www.freedesktop.org/wiki/Software/systemd/NetworkTarget/
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      # https://nixos.org/manual/nixpkgs/stable/#trivial-builder-writeShellApplication
      serviceConfig.ExecStartPre = lib.getExe (
        pkgs.writeShellApplication {
          name = "nixos-config-update";
          runtimeInputs = with pkgs; [
            coreutils
            git
            sudo
          ];

          text = ''
            STATUS_FILE="/var/log/nixos-upgrade-status.log"
            {
              echo "Upgrade Attempt: $(date -Iseconds)"
              echo "------------------------------------------"

              if sudo -u ${cfg.user} git -C "${cfg.flakePath}" pull --ff-only; then
                REV=$(sudo -u ${cfg.user} git -C "${cfg.flakePath}" rev-parse HEAD)
                echo "Git Pull: SUCCESS"
                echo "Revision: ''${REV}"
                echo "NixOS Rebuild: Started."
              else
                echo "Git Pull: FAILED"
                echo "NixOS Rebuild: Skipped."
                exit 1
              fi
            } | tee "$STATUS_FILE"
          '';
        }
      );
    };

    systemd.timers.nixos-upgrade = {
      # https://www.freedesktop.org/software/systemd/man/latest/systemd.timer.html
      timerConfig.OnBootSec = lib.mkIf (cfg.onBootDelay != "-1") (lib.mkDefault cfg.onBootDelay);
    };

    programs.git = {
      # In order to configure git, it must first be enabled
      enable = true;
      config = {
        # Trust this repository if its ownership differs from the Git process owner,
        # otherwise errors can occur (e.g. "repository path not owned by current user")
        # https://git-scm.com/docs/git-config#Documentation/git-config.txt-safedirectory
        safe.directory = [ "${cfg.flakePath}" ];
      };
    };
  };
}
