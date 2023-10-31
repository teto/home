{ config, lib, pkgs, ... }:
{

 home.packages = [
  pkgs.ncmpcpp
  pkgs.mpc_cli
  pkgs.ymuse # GUI
 ];


 services.mpd = {
   enable = true;
   # dataDir = xdg.dataDir
   # playlistDirectory = 
   # extraConfig = 
   # extraArgs = 
   network = {
     # port 
     # startWhenNeeded = true;
   };
 };

 programs.ncmpcpp = {
  enable = true;
  # bindings = #
  # settings = 
   # mpdMusicDir
 };
}

