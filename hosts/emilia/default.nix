{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/optional/amd_gpu.nix
    ../common/optional/auto-upgrade.nix
    ../common/optional/gaming.nix
    ../common/optional/gnome.nix
    ../common/users/pvalov
    ./configuration.nix
  ];

  # Use standard Bulgarian keyboard layout
  services.xserver.xkb.variant = ",,";

  features.auto-upgrade = {
    enable = true;
    user = "pvalov";
    flakePath = "/home/pvalov/workspace/git_projects/nixos-config";
    dates = "daily";
  };
}
