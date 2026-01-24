{
  config,
  lib,
  pkgs,
  ...
}:
let
  dockerEnabled = config.virtualisation.docker.enable;
in
{
  # https://wiki.nixos.org/wiki/Podman
  # https://nixos.wiki/wiki/Podman
  virtualisation = {
    containers = {
      # Enable common /etc/containers config module, which makes options
      # like regiestries/storage/containerConf/policy take effect
      # Podman/Buildah/Skopeo read these system-wide settings
      enable = lib.mkDefault true;

      registries = {
        # Keep it simple with Docker Hub ("docker.io"), without Red Hat's Registry ("quay.io")
        search = [ "docker.io" ];
      };
    };
    podman = {
      enable = true;

      # Create alias: docker -> podman
      # but only when docker is not enabled
      dockerCompat = !dockerEnabled;

      # Users must be in the "podman" group to connect
      dockerSocket.enable = !dockerEnabled;

      defaultNetwork.settings = {
        # Required for podman-compose containers to be able to talk to each other
        dns_enabled = lib.mkDefault true;
      };
    };
  };
  environment.systemPackages = with pkgs; [
    podman-compose
    # podman-tui # optional terminal UI
    # dive # optional tool to explore image layers
  ];
}
