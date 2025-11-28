{
  lib,
  ...
}:
{
  # https://wiki.nixos.org/wiki/Graphics
  hardware.graphics = {
    # Usually defined by desktop environments
    enable = true;

    # 32-bit libs  (OpenGL/Vulkan) for older games, Wine, Steam, etc.
    enable32Bit = lib.mkDefault true;
  };
}
