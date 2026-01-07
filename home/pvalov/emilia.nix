{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.hm.gvariant) mkTuple;
in
{
  imports = [
    ./global
    ../mvalov/optional/bash.nix
    ../mvalov/optional/git.nix
    ../common/optional/gnome
    ../common/optional/gaming
    ../common/optional/joplin.nix
    ../common/optional/keepassxc.nix
  ];

  home.packages = with pkgs; [
    google-chrome
    discord
    signal-desktop
    rustdesk-flutter
  ];

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      sources = lib.mkForce [
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
          "bg"
        ])
      ];
    };
    "system/locale" = {
      region = "bg_BG.UTF-8";
    };
  };
}
