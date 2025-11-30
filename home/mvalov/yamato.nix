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
    ../common/optional/gaming
    ../common/optional/joplin.nix
  ];

  home.packages = with pkgs; [
    google-chrome
    discord
    viber
  ];
}
