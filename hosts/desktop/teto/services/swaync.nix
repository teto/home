# sway notification center
{ config, lib, pkgs, ... }:
{

 imports = [
   ../../../../hm/profiles/swaync.nix
 ];

 services.swaync = {
   enable = true;
 };

}
