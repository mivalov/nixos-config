{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.hm.gvariant) mkTuple;
  inherit (lib) mkDefault;
in
{
  # https://wiki.nixos.org/wiki/GNOME
  dconf = {
    enable = true;

    # dump settings with: dconf dump / > "$(date +'%FT%H-%M')-gnome.dconf"
    # convert settings with: dconf2nix -i input.dconf -o output.nix
    settings = {
      "org/gnome/desktop/calendar" = {
        show-weekdate = mkDefault true;
      };

      "org/gnome/desktop/input-sources" = {
        per-window = mkDefault false;
        sources = [
          (mkTuple [
            "xkb"
            "de"
          ])
          (mkTuple [
            "xkb"
            "us"
          ])
          (mkTuple [
            "xkb"
            "bg+phonetic"
          ])
        ];

        xkb-options = mkDefault [
          "lv3:ralt_switch" # Right Alt (Alt Gr) = access extra keys (level 3)
          "grp:alt_shift_toggle" # Alt + Shift = switch keyboard layout
        ];
      };

      "org/gnome/desktop/interface" = {
        accent-color = mkDefault "blue";
        clock-format = mkDefault "24h";
        clock-show-seconds = mkDefault true;
        clock-show-weekday = mkDefault true;
        color-scheme = mkDefault "prefer-dark";
        show-battery-percentage = mkDefault true;
      };

      "org/gnome/desktop/wm/keybindings" = {
        switch-applications = mkDefault [ "<Super>Tab" ];
        switch-applications-backward = mkDefault [ "<Shift><Super>Tab" ];
        switch-windows = mkDefault [ "<Alt>Tab" ];
        switch-windows-backward = mkDefault [ "<Shift><Alt>Tab" ];
      };

      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = mkDefault true;
        night-light-schedule-automatic = mkDefault false;
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = mkDefault "<Control><Alt>t";
        command = mkDefault "kgx";
        name = mkDefault "Launch Gnome Console";
      };
    };
  };
}
