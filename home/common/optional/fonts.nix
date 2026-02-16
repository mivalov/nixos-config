{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.fonts;
in
{
  options.features.fonts = {
    enableCoreFonts = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = "Enables Microsoft Core Fonts (Arial, Times New Roman, etc.)";
    };

    enableVistaFonts = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = "Enables Microsoft Vista Fonts (Calibry, Cambria, etc.)";
    };

    enableLiberation = lib.mkOption {
      # Usually installed by default via `fonts.enableDefaultPackages`
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Enables open-source alternatives to:
          - Arial -> Liberation Sans
          - Times New Roman -> Liberation Serif
          - Courier New -> Liberation Mono
      '';
    };

    enableCarlito = lib.mkOption {
      # https://fontlibrary.org/en/font/carlito
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Enables metric-compatible alternative to Calibri (Google Carlito)";
    };

    enableCaladea = lib.mkOption {
      # https://fontlibrary.org/en/font/caladea
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Enables metric-compatible alternative to Cambria (Google Caladea)";
    };

    extraFonts = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = [ pkgs.noto-fonts ];
      description = "Adds extra fonts";
    };
  };

  config = {
    # https://wiki.nixos.org/wiki/Fonts
    # https://nixos.wiki/wiki/Fonts
    # Important: makes fonts installed via HM visible to fontconfig/apps
    fonts.fontconfig.enable = true;

    # List available fonts with `fc-list`
    home.packages =
      (lib.optional cfg.enableCoreFonts pkgs.corefonts)
      ++ (lib.optional cfg.enableVistaFonts pkgs.vista-fonts)
      ++ (lib.optional cfg.enableLiberation pkgs.liberation_ttf)
      ++ (lib.optional cfg.enableCarlito pkgs.carlito)
      ++ (lib.optional cfg.enableCaladea pkgs.caladea)
      ++ cfg.extraFonts;
  };
}
