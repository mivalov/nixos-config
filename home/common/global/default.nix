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
  };
}
