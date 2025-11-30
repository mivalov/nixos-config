{
  lib,
  ...
}:
{
  programs.joplin-desktop = {
    enable = lib.mkDefault true;

    # Unfortunately, the extra configs are not always converted correctly.
    # At least for now, the main problem is when using lib.mkDefault
    #extraConfig = {
    # https://joplinapp.org/schema/settings.json
    #locale = lib.mkDefault "en_GB";
    #"markdown.plugin.emoji" = lib.mkDefault true;
    #theme = lib.mkDefault 2;
    #themeAutoDetect = lib.mkDefault false;
    #};
  };
}
