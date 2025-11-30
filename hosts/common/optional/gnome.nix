{
  config,
  lib,
  pkgs,
  ...
}:
{
  # https://wiki.nixos.org/wiki/GNOME
  # Enable the GNOME Desktop Environment.
  services = {
    # GNOME Display Manager (GDM)
    displayManager.gdm = {
      enable = lib.mkDefault true;
      autoSuspend = lib.mkDefault false;
    };
    # GNOME Desktop Manager
    desktopManager.gnome = {
      enable = lib.mkDefault true;
    };
  };

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    dconf-editor
  ];
}
