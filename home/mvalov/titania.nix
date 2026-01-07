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
  ];

  home.packages = with pkgs; [
    rustdesk-flutter
  ];
}
