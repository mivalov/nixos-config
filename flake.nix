{
  description = "MValov's NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
#    disko = {
#      url = "github:nix-community/disko";
#      inputs.nixpkgs.follows = "nixpkgs"
#    };
#    agenix.url = "github:ryantm/agenix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;

    # List of supported system architectures
    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];

    # Pre-import pkgs once for each system
    pkgsFor = nixpkgs.lib.genAttrs systems (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );
    # Function to generate set of attributes for each system
    forAllSystems = func: nixpkgs.lib.genAttrs systems (system: func pkgsFor.${system});

    # Determine the list of host configurations
    hostsDir = ./hosts;
    hostsDirSet = builtins.readDir ./hosts;
    isHost = name:
      hostsDirSet.${name} == "directory"
      && ! builtins.elem name ["common"]
      && builtins.pathExists (hostsDir + "/${name}/default.nix");
    hostNames = builtins.filter isHost (builtins.attrNames hostsDirSet);
  in {
    # Overlays
    overlays = import ./overlays {inherit inputs outputs;};
    # Custom packages
    packages = forAllSystems (pkgs: import ./pkgs {inherit pkgs;});
    # Formatter (enable nix fmt)
    formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);

    # Host configs
    nixosConfigurations = nixpkgs.lib.genAttrs hostNames (
      host: nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [(hostsDir + "/${host}")];
      }
    );

  };
}
