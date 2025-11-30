{
  lib,
  pkgs,
  ...
}:
{
  #imports = [];

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      # man nix.conf - check for available options
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    # Necessary due to https://github.com/NixOS/nix/issues/8508
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 30d";
    };
  };
}
