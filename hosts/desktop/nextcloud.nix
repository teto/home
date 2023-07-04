{ config, flakeInputs, lib, pkgs, ... }:
{
  imports = [
     ../../nixos/profiles/nextcloud.nix
  ];
  services.nextcloud.hostName = "localhost";
}

