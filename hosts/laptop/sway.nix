{ config, lib, pkgs, ... }:
{

  wayland.windowManager.sway = {
    enable = true;

    extraSessionCommands = lib.mkForce "";
    extraOptions = [
      "--verbose"
      "--debug"
    ];
  };

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
