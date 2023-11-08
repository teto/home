# sway notification center
{ config, lib, pkgs, ... }:
{

 imports = [
   ../../../hm/profiles/swaync.nix
 ];

 services.swaync = {
  enable = true;
 };


 xdg.configFile."swaync/config.json".enable = false;
}
