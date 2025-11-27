{
  config,
  lib,
  pkgs,
  ...
}:
{
  # https://nixos.org/manual/nixos/stable/
  # https://wiki.nixos.org/wiki/Graphics
  # https://wiki.nixos.org/wiki/AMD_GPU
  # https://nixos.wiki/wiki/AMD_GPU

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = lib.mkDefault true;
    };
    # Enable on lower resolution output during early boot phases
    #amdgpu.initrd.enable = lib.mkDefault true;
  };
}
