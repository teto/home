{
  flakeSelf,
  config,
  lib,
  pkgs,
  ...
}:
{

  imports = [
    flakeSelf.homeModules.waybar
  ];

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {

        include = [ "~/.config/waybar/desktop.jsonc" ];

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
