{ config, flakeInputs, lib, pkgs, ... }:
{

  imports = [ 
       ../../nixos/profiles/docker-daemon.nix
  ];

}
