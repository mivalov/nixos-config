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
    ../common/users/mvalov
    ./configuration.nix
  ];
}
