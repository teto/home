{ config, lib, pkgs,  ... }:
{

  imports = [
    ../modules/docker-daemon.nix
    ../modules/minio.nix
  ];

  environment.systemPackages = with pkgs; [
    docker-compose
    docker-credential-helpers # (.bin)  # to prevent cleartext passwords in $HOME/.docker/config.json

    # kubebox  # node program, not yet upstreamed
    # kubectl  # kubectl
  ];

}
