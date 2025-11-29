{
  lib,
  ...
}:
{
  # https://github.com/flightlessmango/MangoHud
  # FPS overlay
  programs.mangohud = {
    # Launch option: mangohud %command%
    enable = lib.mkDefault true;
    settings = {
      # https://raw.githubusercontent.com/flightlessmango/MangoHud/master/data/MangoHud.conf
      gpu_name = lib.mkDefault true;
    };
  };
}
