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
      frequency = lib.mkDefault "weekly";
      # In HM release 25.11, frequency will be renamed to dates
      # TODO: After upgrading to the new HM release, replace "frequency" with "dates"
      # dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 30d";
    };
  };
}
