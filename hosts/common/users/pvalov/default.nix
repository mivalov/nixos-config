{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  username = "pvalov";
in
{
  # Define a user account
  users.users.${username} = {
    isNormalUser = true;
    description = "Pavlin Valov";
    extraGroups = ifTheyExist [
      "networkmanager"
      "wheel"
    ];
  };
  home-manager.users.${username} =
    import ../../../../home/${username}/${config.networking.hostName}.nix;
}
