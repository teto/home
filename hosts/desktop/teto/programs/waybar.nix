{ config, lib, pkgs, ... }:
{

  imports = [
    ../../../../hm/profiles/waybar.nix
  ];

  programs.waybar = {
   enable = true;
   settings = {
     mainBar = {

          include = [
            "~/.config/waybar/desktop.jsonc"
          ];
       # output = [
         # "eDP-1"
         # "HDMI-A-1"
       # ];
       # "wlr/taskbar" 
       # modules-left = [
       #  "sway/workspaces"
       #  "sway/mode"
       # ];

    # clock = {
    #     # "timezone": "America/New_York",
    #     # TODO look how to display timezone
    #     timezones = [  "Europe/Paris"  "Asia/Tokyo" ];
    #     tooltip-format= "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    #     format-alt = "{:%Y-%m-%d}";
    #      # on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
    #     on-click = "${pkgs.kitty}/bin/kitty sh -c cal -m3";
    #      # on-click-right = "swaync-client -d -sw";
    #  };

       # "custom/notification" = {
       #   tooltip = false;
       #   format = "{icon}";
       #   format-icons = {
       #     notification = "<span foreground='red'><sup>notifs</sup></span>";
       #     none = "🔔";
       #     inhibited-notification = "🔔inhibited<span foreground='red'><sup>toto</sup></span>";
       #     inhibited-none = "🔔0";
       #     # Do Not Disturb
       #     dnd-notification = "dnd <span foreground='red'><sup>dnd</sup></span>";
       #     dnd-none = "🔕";
       #     dnd-inhibited-notification = "<span foreground='red'>🔕</span>";
       #     dnd-inhibited-none = "🔕   none";
       #   };
       #   return-type = "json";
       #   # exec-if = "which swaync-client";
       #   exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
       #   on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
       #   on-click-right = "swaync-client -d -sw";
       #   escape = true;
       # };
     };
    };
  };

 }
