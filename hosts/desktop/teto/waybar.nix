{ config, lib, pkgs, ... }:
{

  include = [
    ../../../hm/profiles/waybar.nix
  ];

  programs.waybar = let 

   # TODO make sure it has jq in PATH
   githubUpdater = pkgs.writeShellApplication 
    { name = "github-updater";
      runtimeInputs = [ pkgs.coreutils pkgs.curl pkgs.jq ];
      text = (builtins.readFile ../modules/waybar/github.sh);
      checkPhase = ":";
    };


  in {
   enable = true;
   settings = {
     mainBar = {
       layer = "top";
       position = "top";
       height = 30;
       # output = [
         # "eDP-1"
         # "HDMI-A-1"
       # ];
       # "wlr/taskbar" 
       modules-left = [
        "sway/workspaces"
        "sway/mode"
       ];
       modules-center = [
        "sway/window" 
       # "custom/hello-from-waybar"
      ];
       modules-right = [ 
        "mpd"

        # "custom/mymodule#with-css-id"
        # "temperature"
        "idle_inhibitor"
        "custom/github"
        "custom/notmuch"
        "wireplumber"
        "clock"
        "tray"
        "custom/notification"
       ];
    tray= {
        # "icon-size": 21,
        "spacing"= 10;
    };
    mpd = {
        "format" = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ ";
        "format-disconnected" = "Disconnected ";
        "format-stopped" = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
        "unknown-tag" = "N/A";
        "interval" = 2;
        "consume-icons" = {
            "on" = " ";
        };
        "random-icons" = {
            "off" = "<span color=\"#f53c3c\"></span> ";
            "on" = " ";
        };
        "repeat-icons" = {
            "on" = " ";
        };
        "single-icons" = {
            "on" = "1 ";
        };
        "state-icons" = {
            "paused" = "";
            "playing" = "";
        };
        "tooltip-format" = "MPD (connected)";
        "tooltip-format-disconnected" = "MPD (disconnected)";
    };

    idle_inhibitor = {


     "format-icons" = {
       "activated" = "activated";
       "deactivated"= "inhibit";
     };
    };
    wireplumber= {
     "format"= "{volume}% {icon}";
     "format-muted"= "";
     on-click = "helvum";
     on_click = "kitty sh -c alot -l/tmp/alot.log";

     "format-icons"= ["" "" ""];
    };
    clock = {
        # "timezone": "America/New_York",
        # TODO look how to display timezone
        timezones = [  "Europe/Paris"  "Asia/Tokyo" ];
        tooltip-format= "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format-alt = "{:%Y-%m-%d}";
         # on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
        on-click = "${pkgs.kitty}/bin/kitty sh -c cal -m3";

         # on-click-right = "swaync-client -d -sw";

     };
    # cpu= {
    #     format= "{usage}% ";
    #     tooltip= false;
    # };
       "sway/workspaces" = {
        # {name}:
         format= "{name}";
         disable-scroll = false;
         all-outputs = false;
         # disable-scroll-wraparound = true;
         # "disable-markup" : false,
         # format-icons = {
         #    "1" = "";
         #    "2" = "";
         #    "3" = "";
         # };
       };
    temperature= {
        # "thermal-zone": 2,
        # "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
        critical-threshold= 80;
        # // "format-critical": "{temperatureC}°C {icon}",
        format = "{temperatureC}°C {icon}";
        format-icons =  [""  ""  ""];
    };

       "custom/notification" = {
         tooltip = false;
         format = "{icon}";
         format-icons = {
           notification = "<span foreground='red'><sup>notifs</sup></span>";
           none = "🔔";
           inhibited-notification = "🔔inhibited<span foreground='red'><sup>toto</sup></span>";
           inhibited-none = "🔔0";
           # Do Not Disturb
           dnd-notification = "dnd <span foreground='red'><sup>dnd</sup></span>";
           dnd-none = "🔕";
           dnd-inhibited-notification = "<span foreground='red'>🔕</span>";
           dnd-inhibited-none = "🔕   none";
         };
         return-type = "json";
         # exec-if = "which swaync-client";
         exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
         on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
         on-click-right = "swaync-client -d -sw";
         escape = true;
       };
       "custom/github"= {
          format = "{} ";
          "return-type"= "json";
          # The interval (in seconds) in which the information gets polled
          "restart_interval"= 60;
          # "exec"= "$HOME/.config/waybar/github.sh";
          exec = lib.getExe githubUpdater;
          on-click = "${pkgs.xdg_utils}/bin/xdg-open https://github.com/notifications";
      };

     # TODO only on laptop
     network = {
         # // "interface": "wlp2*", // (Optional) To force the use of this interface
         format-wifi = "{essid} ({signalStrength}%) ";
         format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
         format-linked = "{ifname} (No IP) ";
         format-disconnected = "Disconnected ⚠";
         format-alt = "{ifname}: {ipaddr}/{cidr}";
     };

      
      "custom/notmuch" = let 
         notmuchChecker = pkgs.writeShellApplication 
         { name = "waybar-notmuch-module";
           runtimeInputs = [ pkgs.notmuch pkgs.jq ];
           text = builtins.readFile ../modules/waybar/notmuch.sh;
           checkPhase = ":";
         };
      in {
         format = "  : {}";
         max-length = 40;
         return-type = "json";
         # TODO run regularly
         interval = 60;
         on_click = "${pkgs.kitty}/bin/kitty sh -c alot -l/tmp/alot.log";
         # TODO rerun mbsync + notmuch etc
         # TODO read
         # exec-on-event = false;
         on-click-right = "systemctl start --user mbsync.service";
         exec = lib.getExe notmuchChecker;

         # exec = pkgs.writeShellScript "hello-from-waybar" ''
         #   echo "from within waybar"
         # '';
       };
     };
    };
  };

  # TODO flaemshot
  # Unit.PartOf = [ "tray.target" ];
  # Install.WantedBy = [ "tray.target" ];
 }
