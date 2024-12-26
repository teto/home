# GTK_DEBUG=interactive waybar
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
        "custom/github" = {
          format = "{} ï";
          return-type = "json";
          # The interval (in seconds) in which the information gets polled
          restart_interval = 120;
          # "exec"= "$HOME/.config/waybar/github.sh";
          exec = lib.getExe githubUpdater;
          on-click = "xdg-open https://github.com/notifications";
        };

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
          pkgs.xdg-utils # for xdg-open
        ]
      }:${dotfilesPath}/bin";
    };
    Unit.PartOf = [ "tray.target" ];
    Install.WantedBy = [ "tray.target" ];
  };
}
