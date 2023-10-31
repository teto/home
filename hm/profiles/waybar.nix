{ config, lib, pkgs, ... }:
let 
  myLib = pkgs.callPackage ../lib.nix {};
in
{

  programs.waybar =
    let

      # TODO make sure it has jq in PATH
      githubUpdater = pkgs.writeShellApplication
        {
          name = "github-updater";
          runtimeInputs = [ pkgs.coreutils pkgs.curl pkgs.jq ];
          text = (builtins.readFile ../modules/waybar/github.sh);
          checkPhase = ":";
        };


    in
    {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
         fixed-center = false;
          # a way to have a manual definition !
          include = [
            "~/.config/waybar/manual.json"
          ];
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
            "mpd"
          ];
          modules-right = [
            # "mpd"
            "custom/launcher"

            # "custom/mymodule#with-css-id"
            # "temperature"
            "idle_inhibitor"
            "custom/notification"
            "custom/github"
            "custom/notmuch"
            "custom/weather" 
            "wireplumber"
            "tray"
            "custom/power-menu"
            "clock"
          ];
          tray = {
            # "icon-size": 21,
            spacing = 10;
          };
          mpd = {
           # {album} - 
            format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ ";
            #  Disconnected ";
            format-disconnected = "<span color=\"#f53c3c\"></span>";
            # {consumeIcon}{randomIcon}{repeatIcon}
            format-stopped = "{singleIcon}Stopped ";
            unknown-tag = "N/A";
            interval = 2;
            consume-icons = {
              "on" = " ";
            };
            random-icons = {
              off = "<span color=\"#f53c3c\"></span> ";
              on = " ";
            };
            repeat-icons = {
              on = " ";
            };
            "single-icons" = {
              on = "1 ";
            };
            state-icons = {
              paused = "";
              playing = "";
            };

            # TODO give current artist/song
            tooltip-format = "MPD (connected)";
            tooltip-format-disconnected = "MPD (disconnected)";
          };

          idle_inhibitor = {
            # use a screensaver icon
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };

          };
          wireplumber = {
            format = "{volume}% {icon}";
            # "format-muted": ""
            # <sup> </sup> 
            format-muted = "<span background='red'></span>";
            on-click = myLib.muteAudio;
            format-icons = [ "" "" "" ];
          };
          clock = {
            # "timezone": "America/New_York",
            # TODO look how to display timezone
            timezones = [
             "Europe/Paris" 
             "Asia/Tokyo"
            ];
            tooltip-format = "<big>{:%Y %B}</big>\n<tt>{calendar}</tt>";
            format-alt = "{:%Y-%m-%d}";
            # TODO launch ikhal instead
            on-click-right = "${pkgs.kitty}/bin/kitty sh -c cal -m3";
            actions = {
               on-scroll-up = "shift_up";
               on-scroll-down =  "shift_down";
            };

            # on-click-right = "swaync-client -d -sw";

          };
          # cpu= {
          #     format= "{usage}% ";
          #     tooltip= false;
          # };
          "sway/workspaces" = {
            # {name}:
            format = "{name}";
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
          # temperature = {
          #   # "thermal-zone": 2,
          #   # "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
          #   critical-threshold = 80;
          #   # // "format-critical": "{temperatureC}°C {icon}",
          #   format = "{temperatureC}°C {icon}";
          #   format-icons = [ "" "" "" ];
          # };
          "custom/weather" = {
            format = "{} °";
            tooltip = true;
            interval = 3600;
            # --hide-conditions
            # pass location
            exec = "${pkgs.wttrbar}/bin/wttrbar";
            return-type = "json";
          };
          "custom/notification" = {
            tooltip = true;
            format = "{text} {icon}";
            format-icons = {
              # notification = "<span foreground='red'><sup>notifs</sup></span>";
              none = "";
              inhibited-notification = "inhibited<span foreground='red'><sup>toto</sup></span>";
              inhibited-none = "0";
              # Do Not Disturb
              dnd-notification = "<span foreground='red'><sup>Notifs</sup></span>";
              dnd-none = "no notifs";
              dnd-inhibited-notification = "dnd<span foreground='red'><sup>dnd</sup></span>";
              dnd-inhibited-none = "none";
            };
            return-type = "json";
            # exec-if = "which swaync-client";
            exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
            on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
            on-click-right = "swaync-client -d -sw";
            escape = true;
          };
          "custom/github" = {
            format = "{} ";
            return-type = "json";
            # The interval (in seconds) in which the information gets polled
            restart_interval = 120;
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


          "custom/notmuch" =
            let
              notmuchChecker = pkgs.writeShellApplication
                {
                  name = "waybar-notmuch-module";
                  runtimeInputs = [ pkgs.notmuch pkgs.jq ];
                  text = builtins.readFile ../modules/waybar/notmuch.sh;
                  checkPhase = ":";
                };
            in
            {
              format = " {} ";
              max-length = 40;
              return-type = "json";
              # TODO run regularly
              interval = 120;
              on_click = "${pkgs.kitty}/bin/kitty sh -c alot -l/tmp/alot.log";
              # TODO rerun mbsync + notmuch etc
              # TODO read
              # exec-on-event = false;
              on-click-right = "systemctl start mbsync.service";
              exec = lib.getExe notmuchChecker;

              # exec = pkgs.writeShellScript "hello-from-waybar" ''
              #   echo "from within waybar"
              # '';
            };
        };
      };
    };

    systemd.user.services.waybar.Service.Environment ="PATH=${lib.makeBinPath [ pkgs.wlogout ]}";

}
