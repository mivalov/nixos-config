{
  lib,
  ...
}:
{
  programs.keepassxc = {
    enable = lib.mkDefault true;
    autostart = lib.mkDefault false;
    # It actually makes it hard work with read-only config file
    # especially when you integrate it with a browser and want to share things
    # settings = {
    #   # https://github.com/keepassxreboot/keepassxc/blob/develop/src/core/Config.cpp
    #   Browser = {
    #     Enabled = lib.mkDefault true;
    #     # Setting this to true, might cause errors
    #     UpdateBinaryPath = lib.mkDefault false;
    #   };
    #   General = {
    #     ConfigVersion = lib.mkDefault 2;
    #   }
    #   GUI = {
    #     ApplicationTheme = lib.mkDefault "dark";
    #     CompactMode = lib.mkDefault false;
    #     HideUsernames = lib.mkDefault true;
    #   };
    # };
  };
}
