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
  # annoying to have to rebuild in order to check
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
    text = builtins.readFile ../../bin/waybar-notmuch-module;
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
          # <span font-family=\"Font Awesome 6 Pro Regular\">{icon}</span> {capacity}%
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
          # https://fontawesome.com/icons/cloud?f=classic&s=solid
          format = " {}  ";
          tooltip = true;
          interval = 3600;
          # --hide-conditions
          # pass location
          exec = "${pkgs.wttrbar}/bin/wttrbar";
          return-type = "json";
        };
      };
    };
  };

  # TODO
  systemd.user.services.waybar = lib.mkIf config.programs.waybar.enable {
    Service = {
      # to get fonts https://github.com/nix-community/home-manager/issues/4099#issuecomment-1605483260
      Environment = "PATH=$PATH:${
        lib.makeBinPath [
          notmuchChecker
          pkgs.swaynotificationcenter
          pkgs.wlogout
          pkgs.fuzzel
          pkgs.wofi
          pkgs.wttrbar # for weather module
          pkgs.xdg-utils # for xdg-open

          # for the github notifier
          pkgs.curl
          pkgs.jq
        ]
        # needs to find nvidia smi as well
      }:${dotfilesPath}/bin";
    };
    Unit.PartOf = [ "tray.target" ];
    Install.WantedBy = [ "tray.target" ];
  };
}
