{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../common/global
  ];

  # Sensible defaults, handy for stand-alone HM later on
  home = {
    username = lib.mkDefault "mvalov";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "25.05";

    packages = [
      # Install the CLI from the HM input (matches module exactly)
      inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager
    ];
  };
}
