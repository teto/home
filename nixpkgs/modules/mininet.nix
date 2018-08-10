{ config, lib, pkgs,  ... }:
{


  # will install openvswitch
  programs.mininet = {
    enable = true;
  };

}
