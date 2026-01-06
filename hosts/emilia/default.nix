{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/optional/gnome.nix
    ../common/optional/amd_gpu.nix
    ../common/optional/gaming.nix
    ../common/users/pvalov
    ./configuration.nix
  ];

  # Use standard Bulgarian keyboard layout
  services.xserver.xkb.variant = ",,";
}
