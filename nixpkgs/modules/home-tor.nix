{ config, lib, pkgs,  ... }:
{
  home.packages = with pkgs; [
    nyx
    firefoxPackages.tor-browser
  ];

}
