{
  config,
  lib,
  pkgs,
  dotfilesPath,
  ...
}:
let
  myLib = pkgs.tetoLib;

  # TODO make sure it has jq in PATH
  githubUpdater = pkgs.writeShellApplication {
    name = "github-updater";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.curl
      pkgs.jq
    ];
    text = (builtins.readFile ../modules/waybar/github.sh);
    checkPhase = ":";
  };

  notmuchChecker = pkgs.writeShellApplication {
    name = "waybar-notmuch-module";
    runtimeInputs = [
      pkgs.notmuch
      pkgs.jq
    ];
    text = builtins.readFile ../modules/waybar/notmuch.sh;
    checkPhase = ":";
  };
in
{

  programs.waybar = {
    enable = true;

    systemd.enable = true;

    settings = {
      mainBar = {
        fixed-center = false;
        # a way to have a manual definition !
        include = [ "~/.config/waybar/common.jsonc" ];

        wireplumber = {
          format = "{volume}% {icon}";
          # "format-muted": "ï¦"
          # <sup> </sup> 
          # 🔈
          format-muted = "<span background='red'>🔇</span>";
          on-click = myLib.muteAudio;
          format-icons = [
            "🔈"
            "🔉"
            "🔊"
          ];
        };
        "custom/weather" = {
          format = "{} Â°";
          tooltip = true;
          interval = 3600;
          # --hide-conditions
          # pass location
          exec = "${pkgs.wttrbar}/bin/wttrbar";
          return-type = "json";
        };
        #       "custom/notification" = {
        #         tooltip = false;
        #         # format = "{icon}";
        #         format = "{} {icon} ";
        #
        #         format-icons = {
        # # //         "5": "ïµ",
        # # //         "urgent": "ïª",
        # # //         "focused": "ï",
        # # //         "default": "ï"
        #
        # # ïï¶ª
        #           notification = "<span foreground='red'>ï³<span>";
        #           none = "no notifs ï¶ ";
        #           inhibited-notification = "inhibited<span foreground='red'><sup>toto</sup></span>";
        #           inhibited-none = "0 inhibted";
        #           # Do Not Disturb
        #           dnd-notification = "<span foreground='red'><sup>Notifs</sup></span>";
        #           dnd-none = "no notifs (dnd)";
        #           dnd-inhibited-notification = "dnd<span foreground='red'><sup>dnd</sup></span>";
        #           dnd-inhibited-none = "none";
        #         };
        #         return-type = "json";
        #         # exec-if = "which swaync-client";
        #         exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
        #         on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
        #         on-click-right = "swaync-client -d -sw";
        #         escape = true;
        #       };
        "custom/github" = {
          format = "{} ï";
          return-type = "json";
          # The interval (in seconds) in which the information gets polled
          restart_interval = 120;
          # "exec"= "$HOME/.config/waybar/github.sh";
          exec = lib.getExe githubUpdater;
          on-click = "xdg-open https://github.com/notifications";
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
      };
    };
  };

  # TODO
  systemd.user.services.waybar = lib.mkIf config.programs.waybar.enable {
    Service = {
      # to get fonts https://github.com/nix-community/home-manager/issues/4099#issuecomment-1605483260
      Environment = "PATH=${
        lib.makeBinPath [
          notmuchChecker
          pkgs.swaynotificationcenter
          pkgs.wlogout
          pkgs.fuzzel
          pkgs.wofi
          pkgs.wttrbar # for weather module
          pkgs.xdg_utils # for xdg-open
        ]
      }:${dotfilesPath}/bin";
    };
    Unit.PartOf = [ "tray.target" ];
    Install.WantedBy = [ "tray.target" ];
  };
}
