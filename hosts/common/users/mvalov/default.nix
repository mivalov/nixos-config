{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  username = "mvalov";
in
{
  # Define a user account
  users.users.${username} = {
    isNormalUser = true;
    description = "Miroslav Valov";
    extraGroups = ifTheyExist [
      "docker"
      "networkmanager"
      "podman"
      "wheel"
    ];
    # TODO: password, initialhashedPassword or hashedPasswordFile??
    # TODO: openssh.authorizedKeys??
    #packages = with pkgs; [
    #  # thunderbird
    #];

  };
  home-manager.users.${username} =
    import ../../../../home/${username}/${config.networking.hostName}.nix;
}
