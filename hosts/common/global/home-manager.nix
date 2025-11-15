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

    # https://www.reddit.com/r/NixOS/comments/1m0g1e9/get_options_for_specific_homemanager_module_user/
    # Extra Home Manager modules that are applied to *every* HM user
    sharedModules = [
      # Home Manager module written as a function, takes module arguments (like options, lib, ...)
      # and returns an attrset
      (
        { options, lib, ... }:
        {
          # define a new HM option `hmInternalOptions`,
          # and lives under: config.home-manager.users.<user>.hmInternalOptions (inspect in a repl)
          # This way one can inspect/debug custom feature definitions within the HM configs
          # e.g. options.features.bash.gitPrompt
          options.hmInternalOptions = lib.mkOption {
            # attribute set of anything, flexible enough to hold the entire HM options tree
            type = lib.types.attrsOf lib.types.anything;

            # copies the full HM options tree for the user into `hmInternalOptions`
            default = options;

            # in docs, show/render literally `options` as Nix code
            defaultText = lib.literalExpression "options";

            description = "Internal: expose the full Home Manager options tree for REPL introspection.";

            # marks this option as internal (for tools, etc)
            internal = true;

            # hide it from normal option listings/docs, keeps `home-manager options` output clean
            visible = false;

            # not meant to be overriden, only there for REPL introspection
            readOnly = true;
          };
        }
      )
    ];
  };
}
