{
  inputs,
  outputs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    #https://discourse.nixos.org/t/home-manager-useuserpackages-useglobalpkgs-settings/34506
    # HM inherits the system-wide package set from NixOS
    # disables HM's own package management options
    # benefits: ensures consistency b/n user and system packages,
    # as both will reference the same package set
    # useful for users who want to maintain a unified package config (system/HM)
    useGlobalPkgs = true;

    # allows HM to install user-specific packages through the user config
    # it enables the use of `users.users.<name>.packages` option for package management
    # benefit: user-level package management without affecting the global system config
    useUserPackages = true;

    backupFileExtension = "bak";
    extraSpecialArgs = { inherit inputs outputs; };
  };
}
