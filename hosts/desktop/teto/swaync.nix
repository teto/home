# sway notification center
{ config, lib, pkgs, ... }:
{

 imports = [
   ../../../hm/profiles/swaync.nix
 ];
 # programs.swaync = {
 #  enable = true;

 # };

}
