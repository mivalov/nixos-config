{
  pkgs,
  ...
}:
{
  # https://nixos.wiki/wiki/LibreOffice
  # https://wiki.nixos.org/wiki/LibreOffice
  home.packages = with pkgs; [
    # stable variant; the same as libreoffice-still
    libreoffice

    # spellcheck
    hunspell
    hunspellDicts.en_US
    hunspellDicts.de_DE

    # hyphenation
    hyphenDicts.en_US
    hyphenDicts.de_DE
  ];
}
