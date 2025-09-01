{
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}:
{
  imports = [ ];
  nixpkgs = {
    config = {
      # Allow unfree packages
      allowUnfree = true;
    };
  };
  nix = {
    settings = {
      # Enable the Flakes feature and the new nix cli
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
  };
}
