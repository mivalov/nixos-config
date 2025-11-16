{
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}:
{
  imports = [
    ./keyboard.nix
    ./home-manager.nix
  ];

  nixpkgs = {
    config = {
      # Allow unfree packages
      allowUnfree = lib.mkDefault true;
    };
  };
  nix = {
    settings = {
      # Enable the Flakes feature and the new nix cli
      experimental-features = lib.mkDefault [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 30d";
    };
    optimise.automatic = lib.mkDefault true;
  };
}
