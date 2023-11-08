{ config, lib, pkgs, ... }:
{

 services.swaync = {
  enable = true;

 };

 systemd.user.services.swaync.Service.Environment = [
   "G_MESSAGES_DEBUG=all"
   "PATH=${lib.makeBinPath [ pkgs.wlogout pkgs.libnotify pkgs.swaylock  pkgs.fuzzel pkgs.wofi ]}" 
  ];

}
