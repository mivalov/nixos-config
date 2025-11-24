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
    };
  };
}
