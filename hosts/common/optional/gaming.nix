{
  config,
  lib,
  pkgs,
  ...
}:
{
  # https://wiki.nixos.org/wiki/Steam
  # https://nixos.wiki/wiki/Steam
  programs = {
    # Daemon that can improve gaming performance
    # Launch option: gamemoderun %command%
    gamemode = {
      enable = lib.mkDefault true;
    };

    steam = {
      enable = lib.mkDefault true;

      # https://store.steampowered.com/remoteplay/
      # Open the ports that Steam uses for Remote Play so that other devices can connect to me
      remotePlay.openFirewall = lib.mkDefault false;

      # https://help.steampowered.com/en/faqs/view/0E82-09BC-324C-CB12
      # Open the ports that Steam's dedicated servers typically use so people can join my server
      dedicatedServer.openFirewall = lib.mkDefault false;

      # Could help solve issues with upscaling or resolutions on specific DE/WM.
      # Instead of using Gnome/KDE, "boot to Steam Deck", meaning it can function as
      # a minimal desktop environment, resembling the Steam Deck hardware console.
      # Enabling it might be an overkill for most cases, instead if you only need
      # the wrapper, you could simply add to `environment.systemPackages` or `home.packages` (HM)
      gamescopeSession.enable = lib.mkDefault false;
    };
  };

  # Launch option: gamescope %command%
  #environment.systemPackages = with pkgs; [gamescope];
}
