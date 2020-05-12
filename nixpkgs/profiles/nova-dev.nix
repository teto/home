{ config, lib, pkgs,  ... }:
{

  imports = [
    ../modules/docker-daemon.nix
  ];

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

}
