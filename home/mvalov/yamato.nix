{
  config,
  lib,
  ...
}:
{
  imports = [
    ./global
    ./optional/bash.nix
    ./optional/git.nix
  ];
  # when you want to override default bash feature configs
  #config.features.bash = {
  #  #ps1 = lib.concatStrings [];
  #  #gitPrompt = {showDirtyState = true;};
  #};
}
