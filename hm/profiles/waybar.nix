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
            "~/.config/waybar/manual.jsonc"
          ];

          wireplumber = {
            format = "{volume}% {icon}";
            # "format-muted": "ï¦"
            # <sup> </sup> 
            # 🔈
            format-muted = "<span background='red'>🔇</span>";
            on-click = myLib.muteAudio;
            format-icons = [ "🔈" "🔉" "🔊" ];
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
            # or a terminal
            on-click-right = "kitty sh -c cal -m3";
            actions = {
               on-scroll-up = "shift_up";
               on-scroll-down =  "shift_down";
            };

            # on-click-right = "swaync-client -d -sw";

          };
          # cpu= {
          #     format= "{usage}% ï";
          #     tooltip= false;
          # };
          # temperature = {
          #   # "thermal-zone": 2,
          #   # "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
          #   critical-threshold = 80;
          #   # // "format-critical": "{temperatureC}Â°C {icon}",
          #   format = "{temperatureC}Â°C {icon}";
          #   format-icons = [ "ï«" "ï" "ï©" ];
          # };
          "custom/weather" = {
            format = "{} Â°";
            tooltip = true;
            interval = 3600;
            # --hide-conditions
            # pass location
            exec = "${pkgs.wttrbar}/bin/wttrbar";
            return-type = "json";
          };
          "custom/notification" = {
            tooltip = false;
            # format = "{icon}";
            format = "{} {icon} ";

            format-icons = {
    # //         "5": "ïµ",
    # //         "urgent": "ïª",
    # //         "focused": "ï",
    # //         "default": "ï"

    # ïï¶ª
              notification = "<span foreground='red'>ï³<span>";
              none = "no notifs ï¶ ";
              inhibited-notification = "inhibited<span foreground='red'><sup>toto</sup></span>";
              inhibited-none = "0 inhibted";
              # Do Not Disturb
              dnd-notification = "<span foreground='red'><sup>Notifs</sup></span>";
              dnd-none = "no notifs (dnd)";
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
            format = "{} ï";
            return-type = "json";
            # The interval (in seconds) in which the information gets polled
            restart_interval = 120;
            # "exec"= "$HOME/.config/waybar/github.sh";
            exec = lib.getExe githubUpdater;
            on-click = "${pkgs.xdg_utils}/bin/xdg-open https://github.com/notifications";
          };

          # TODO only on laptop
          # network = {
          #   # // "interface": "wlp2*", // (Optional) To force the use of this interface
          #   format-wifi = "{essid} ({signalStrength}%) ï«";
          #   format-ethernet = "{ifname}: {ipaddr}/{cidr} ï";
          #   format-linked = "{ifname} (No IP) ï";
          #   format-disconnected = "Disconnected â ";
          #   format-alt = "{ifname}: {ipaddr}/{cidr}";
          # };


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
              format = " {}ï  ";
              max-length = 40;
              return-type = "json";
              # TODO run regularly
              interval = 120;
              on_click = "${pkgs.kitty}/bin/kitty sh -c alot -l/tmp/alot.log";
              # TODO rerun mbsync + notmuch etc
              # exec-on-event = false;
              # TODO create
              on-click-right = "systemctl start mbsync.service";
              exec = lib.getExe notmuchChecker;

              # exec = pkgs.writeShellScript "hello-from-waybar" ''
              #   echo "from within waybar"
              # '';
            };
        };
      };
    };

    # TODO
    systemd.user.services.waybar = lib.mkIf config.services.waybar.enable {
      Service = {
        # to get fonts https://github.com/nix-community/home-manager/issues/4099#issuecomment-1605483260
        Environment ="PATH=${lib.makeBinPath [
          pkgs.wlogout pkgs.fuzzel pkgs.wofi
          pkgs.swaynotificationcenter
          pkgs.wttrbar
        ]}:${config.home.profileDirectory}/bin";
       };
       Unit.PartOf = [ "tray.target" ];
       Install.WantedBy = [ "tray.target" ];
    };
}
