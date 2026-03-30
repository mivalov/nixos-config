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
  # Strategy: 2-Step auto-upgrade - "pull and rebuild":
  # 1. Pre-flight: A shell script runs as unprivileged user to `git pull`
  #    the NixOS config repository using the user's SSH keys.
  #    This fetches only the new commits (delta), which is faster,
  #    and can also handle access to one or more private repos without
  #    the need to provide git credentials for the root user
  # 2. Rebuild: The native nixos-upgrade service then rebuilds the system
  #    (`nixos-rebuild boot`) using the local flake path.
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
      '';
    };

    onBootDelay = lib.mkOption {
      # https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html
      type = lib.types.str;
      default = "3min";
      example = "5min";
      description = ''
        Add a fixed on-boot delay before each automatic system upgrade.
        The delay is useful to let the OS finish loading services.
        This value must be a time span in the format specified by
        {manpage}`systemd.time(7)`.
      '';
    };

    randomizedDelaySec = lib.mkOption {
      # https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html
      type = lib.types.str;
      default = "0";
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
      flake = lib.mkDefault "git+file://${cfg.flakePath}#${config.networking.hostName}";
      operation = lib.mkDefault "boot";
      dates = lib.mkDefault cfg.dates;
      flags = [
        # Ensure nix uses the pinned versions in 'flake.lock'
        "--no-update-lock-file"
        # Forbid nix from writing to the disk, avoiding conflicts on `git pull`
        "--no-write-lock-file"
        #"--print-build-logs"
      ];
      randomizedDelaySec = lib.mkDefault cfg.randomizedDelaySec;
      persistent = lib.mkDefault cfg.persistent;
    };

    # Extend the existing nixos-upgrade service
    systemd.services.nixos-upgrade = {
      # Ensure network is available before starting the service
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

              if sudo -u ${cfg.user} git -C "${cfg.flakePath}" pull; then
                REV=$(sudo -u ${cfg.user} git -C "${cfg.flakePath}" rev-parse HEAD)
                echo "Git Pull: SUCCESS"
                echo "Revision: ''${REV}"
                echo "NixOS Rebuild: Starting..."
              else
                echo "Git Pull: FAILED"
                echo "NixOS Rebuild: Skipping."
                exit 1
              fi
            } > "$STATUS_FILE"
          '';
        }
      );
    };

    systemd.timers.nixos-upgrade = {
      # https://www.freedesktop.org/software/systemd/man/latest/systemd.timer.html
      timerConfig.OnBootSec = lib.mkDefault cfg.onBootDelay;
    };

    # In case of errors (repository path not owned by current user) -> mark repo as safe
    # https://git-scm.com/docs/git-config#Documentation/git-config.txt-safedirectory
    programs.git.config.safe.directory = [ "${cfg.flakePath}" ];
  };
}
