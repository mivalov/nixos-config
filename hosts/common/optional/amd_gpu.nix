{
  config,
  lib,
  pkgs,
  ...
}:
{
  # https://nixos.org/manual/nixos/stable/
  # https://wiki.nixos.org/wiki/Graphics
  imports = [
    ./graphics.nix
  ];

  # https://wiki.nixos.org/wiki/AMD_GPU
  # https://nixos.wiki/wiki/AMD_GPU
  hardware = {
    # Enable on lower resolution output during early boot phases
    #amdgpu.initrd.enable = lib.mkDefault true;
  };
}
