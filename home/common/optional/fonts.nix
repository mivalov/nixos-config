{
  pkgs,
  ...
}:
{
  # https://wiki.nixos.org/wiki/Fonts
  # https://nixos.wiki/wiki/Fonts
  # Important: makes fonts installed via HM visible to fontconfig/apps
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    corefonts # Arial, TimesNewRoman, etc.
    # liberation_ttf # Liberation fonts, alternatives to Arial, TimesNewRoman
    # vista-fonts # Calibri/Cambria
    # carlito # Alternative to Calibri
    # caladea # Alternative to Cambria
  ];
}
