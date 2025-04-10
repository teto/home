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
  # githubUpdater = pkgs.writeShellApplication {
  #   name = "github-updater";
  #   runtimeInputs = [
  #     pkgs.coreutils
  #     pkgs.curl
  #     pkgs.jq
  #   ];
  #   text = (builtins.readFile ../modules/waybar/github.sh);
  #   checkPhase = ":";
  # };

in
# notmuchChecker = pkgs.writeShellApplication {
#   name = "waybar-notmuch-module";
#   runtimeInputs = [
#     pkgs.notmuch
#     pkgs.jq
#   ];
#   text = builtins.readFile ../../bin/waybar-notmuch-module;
#   checkPhase = ":";
# };
{

  programs.waybar = {
    enable = true;

    systemd.enable = true;

    # settings = {
    #   mainBar = {
    #     fixed-center = false;
    #     # a way to have a manual definition !
    #     include = [ "~/.config/waybar/common.jsonc" ];
    #
    #     wireplumber = {
    #       format = "{volume}% {icon}";
    #       # 🔈
    #       format-muted = "<span background='red'>🔇</span>";
    #       on-click = myLib.muteAudio;
    #       format-icons = [
    #         "🔈"
    #         "🔉"
    #         "🔊"
    #       ];
    #     };
    #     "custom/weather" = {
    #       # https://fontawesome.com/icons/cloud?f=classic&s=solid
    #       format = " {}  ";
    #       tooltip = true;
    #       interval = 3600;
    #       # --hide-conditions
    #       # pass location
    #       exec = "${pkgs.wttrbar}/bin/wttrbar";
    #       return-type = "json";
    #     };
    #   };
    # };
  };

  # TODO
  systemd.user.services.waybar = lib.mkIf config.programs.waybar.enable {
    Service = {
      # to get:
      # - fonts https://github.com/nix-community/home-manager/issues/4099#issuecomment-1605483260
      # - nvidia-smi
      Environment = "PATH=$PATH:/etc/profiles/per-user/teto/bin:/run/current-system/sw/bin:${
        lib.makeBinPath [
          # notmuchChecker
          pkgs.curl
          pkgs.fuzzel
          # for the github notifier
          pkgs.world-wall-clock
          pkgs.jq
          pkgs.nvidia-system-monitor-qt
          pkgs.swaynotificationcenter
          pkgs.wlogout
          pkgs.wofi
          pkgs.wttrbar # for weather module
          pkgs.xdg-utils # for xdg-open

          pkgs.python3 # for khal
        ]
        # needs to find nvidia smi as well
      }:${dotfilesPath}/bin";
    };
    Unit.PartOf = [ "tray.target" ];
    Install.WantedBy = [ "tray.target" ];
  };
}
