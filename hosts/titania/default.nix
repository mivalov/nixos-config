{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/users/mvalov
    ./configuration.nix
  ];
}
