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

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "google-chrome.desktop"
        "org.gnome.Console.desktop"
        "discord.desktop"
        "signal.desktop"
        "steam.desktop"
        "com.heroicgameslauncher.hgl.desktop"
        "rustdesk.desktop"
        "org.keepassxc.KeePassXC.desktop"
        "joplin.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Settings.desktop"
      ];
    };
  };
}
