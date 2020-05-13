{ config, lib, pkgs,  ... }:
{

  # imports = [
  #   ../modules/docker-daemon.nix
  # ];

  home.packages = with pkgs; [
  # environment.systemPackages = with pkgs; [
    chromium
  ];

}

