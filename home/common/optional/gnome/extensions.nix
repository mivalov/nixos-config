{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.hm.gvariant) mkInt32;
  inherit (lib) mkDefault;
in
{
  # https://wiki.nixos.org/wiki/GNOME
  home.packages = with pkgs.gnomeExtensions; [
    caffeine
    dash-to-dock
    transparent-top-bar-adjustable-transparency
    weather-oclock
  ];

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        enabled-extensions = with pkgs.gnomeExtensions; [
          caffeine.extensionUuid
          dash-to-dock.extensionUuid
          transparent-top-bar-adjustable-transparency.extensionUuid
          weather-oclock.extensionUuid
        ];
      };

      "com/ftpix/transparentbar" = {
        transparency = mkDefault 25;
      };

      "org/gnome/shell/extensions/dash-to-dock" = {
        apply-custom-theme = mkDefault false;
        autohide-in-fullscreen = mkDefault false;
        background-opacity = mkDefault 0.25;
        click-action = mkDefault "minimize-or-previews";
        custom-theme-shrink = mkDefault false;
        dash-max-icon-size = mkDefault 48;
        dock-fixed = mkDefault false;
        dock-position = mkDefault "BOTTOM";
        height-fraction = mkDefault 0.9;
        icon-size-fixed = mkDefault false;
        intellihide-mode = mkDefault "FOCUS_APPLICATION_WINDOWS";
        middle-click-action = mkDefault "launch";
        multi-monitor = mkDefault true;
        preferred-monitor = mkDefault (-2); # active/focused monitor (dynamic)
        #preferred-monitor-by-connector = mkDefault "eDP-1";
        running-indicator-style = mkDefault "DASHES";
        shift-click-action = mkDefault "minimize";
        shift-middle-click-action = mkDefault "launch";
        show-trash = mkDefault false;
        transparency-mode = mkDefault "FIXED";
      };

      "org/gnome/shell/extensions/weather-oclock" = {
        weather-after-clock = mkDefault false;
      };
    };
  };
}
