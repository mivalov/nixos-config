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
    ../common/optional/nvidia.nix
    ../common/optional/podman.nix
    ../common/optional/gaming.nix
    ../common/users/mvalov
    ./configuration.nix
  ];

  features.nvidia = {
    enable = true;
    primeMode = "sync";
    igpu.type = "intel";
    igpu.busId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}
