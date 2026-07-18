{
  lib,
  ...
}:
{
  # FPS overlay
  # https://github.com/flightlessmango/MangoHud
  programs.mangohud = {
    # Launch option: mangohud %command%
    enable = lib.mkDefault true;
    settings = {
      # https://raw.githubusercontent.com/flightlessmango/MangoHud/master/data/MangoHud.conf
      # To disable parameters enabled by default, set them explicitly to 0 (e.g. fps=0)
      cpu_stats = lib.mkDefault true;
      cpu_temp = lib.mkDefault true;
      fps = lib.mkDefault true;
      frametime = lib.mkDefault true;
      frame_timing = lib.mkDefault true;
      gpu_name = lib.mkDefault true;
      gpu_stats = lib.mkDefault true;
      gpu_temp = lib.mkDefault true;
      position = lib.mkDefault "bottom-right";
      ram = lib.mkDefault true;
      text_outline = lib.mkDefault true;
      vram = lib.mkDefault true;
      wine = lib.mkDefault true;
    };
  };
}
