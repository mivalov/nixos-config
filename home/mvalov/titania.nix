{
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
    ../common/optional/zed-editor.nix
  ];

  home.packages = with pkgs; [
    rustdesk-flutter
    vlc
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Console.desktop"
        "dev.zed.Zed.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Settings.desktop"
      ];
    };
  };
}
