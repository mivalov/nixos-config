{
  config,
  lib,
  ...
}:
{
  # Keyboard layouts for graphical world (X/Wayland - e.g. Gnome, KDE, etc.)
  services.xserver = {
    enable = lib.mkDefault true;
    xkb = {
      # 3 layouts: German, English, Bulgarian
      layout = lib.mkDefault "de,us,bg";
      # Variants map by position (no variants for de/us)
      variant = lib.mkDefault ",,phonetic";
      # Switch layouts: Alt+Shift
      options = lib.mkDefault "grp:alt_shift_toggle";
    };
  };

  # Keyboard layout for consoles (TTYs - Ctrl+Alt+F1...F6)
  console.keyMap = lib.mkDefault "de";
}
