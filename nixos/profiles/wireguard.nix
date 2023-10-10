{ config, lib, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.wireguard-tools
  ];
}

