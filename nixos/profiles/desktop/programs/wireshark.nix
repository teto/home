{ config, pkgs, lib, ... }:
{
  # won't work on nixos yet
  # programs.wireshark. 
    enable = true; # installs setuid
    package = pkgs.wireshark-cli; # which one

}
