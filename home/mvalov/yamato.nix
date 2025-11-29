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
  ];

  home.packages = with pkgs; [
    discord
    google-chrome
    viber
  ];
}
