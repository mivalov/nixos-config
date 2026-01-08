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
  ];

  home.packages = with pkgs; [
    rustdesk-flutter
  ];
}
