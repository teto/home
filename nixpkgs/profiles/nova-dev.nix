{ config, lib, pkgs,  ... }:
{

  imports = [
    ../modules/docker-daemon.nix
  ];

  environment.systemPackages = with pkgs; [
    docker-compose
    docker-credential-helpers # (.bin)  # to prevent cleartext passwords in $HOME/.docker/config.json
  ];

}
