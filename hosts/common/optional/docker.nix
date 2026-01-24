{
  lib,
  pkgs,
  ...
}:
{
  # https://wiki.nixos.org/wiki/Docker
  # https://nixos.wiki/wiki/Docker
  virtualisation.docker = {
    # Optionally, add the "docker" group to your user to run docker without sudo
    # This, however, is effectively equivalent to being root
    # Check the above-mentioned docs for more info
    enable = true;
  };

  # In case the docker plugins (compose/buildx) are missing
  #environment.systemPackages = with pkgs; [
  #  docker-compose
  #  docker-buildx
  #];
}
