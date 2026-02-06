{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./global
    ./optional/bash.nix
    ./optional/git.nix
    ../common/optional/gnome
    ../common/optional/fonts.nix
    ../common/optional/office.nix
    ../common/optional/gaming
    ../common/optional/joplin.nix
    ../common/optional/keepassxc.nix
  ];

  home.packages = with pkgs; [
    google-chrome
    discord
    viber
    signal-desktop
    rustdesk-flutter
    bruno
  ];
}
