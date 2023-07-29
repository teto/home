{ config, lib, pkgs, ... }:
{
  programs.waybar = {
   settings = {
     mainBar = {
       modules-right = [ 
        "battery"
        "bluetooth"
        "network"
        # "backlight"
       ];
       battery = {

        format = "{time} {icon}";
       };
    };
    };
  };
}
