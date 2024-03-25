{ config, lib, pkgs, ... }:
{

  include = [
    ../../../hm/profiles/waybar.nix
  ];

  programs.waybar = {
   settings = {
     mainBar = {
       modules-right = [ 
        "battery"
        "bluetooth"
        "network"
        "backlight"
       ];

       battery = {
         # 'DPL': 'DPL',
         # "DIS": "Discharging",
         # "CHR": "Charging",
         # "FULL": "",

        states= {
           warning= 10;
           critical= 5;
        };
        format = "{time} {icon}";
        # "format"= "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-plugged = "{capacity}% ";

        format-alt = "{time} {icon}";
        format-full = "";
        format-icons = ["" "" "" "" ""];
       };
       # bluetooth = {};
    };
    };
  };
}
