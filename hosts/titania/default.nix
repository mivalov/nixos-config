{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/optional/auto-upgrade.nix
    ../common/optional/gnome.nix
    ../common/users/mvalov
    ./configuration.nix
  ];

  features.auto-upgrade = {
    enable = true;
    user = "mvalov";
    flakePath = "/home/mvalov/workspace/git_projects/nixos-config";
    dates = "hourly";
  };
}
