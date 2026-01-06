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
    username = lib.mkDefault "pvalov";
    # if one or more standard directories are missing from the home dir,
    # e.g., Desktop, Documents, Music, Pictures, Public, Templates, Videos
    # to automatically create them, just run: `xdg-user-dirs-update`
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "25.11";

    packages = [
      # Install the CLI from the HM input (matches module exactly)
      inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager
    ];
  };
}
