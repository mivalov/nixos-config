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
    # before editing, check the options and docs
    enable = true;
    primeMode = "sync";
    igpu.type = "intel";
    igpu.busId = "PCI:0@0:2:0"; # 0000:00:02.0
    nvidiaBusId = "PCI:1@0:0:0"; # 0000:01:00.0
  };
}
