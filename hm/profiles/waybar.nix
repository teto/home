# GTK_DEBUG=interactive waybar
{
  config,
  lib,
  pkgs,
  dotfilesPath,
  ...
}:
{

  programs.waybar = {
    enable = true;

    systemd.enable = true;

    # settings = {
    #   mainBar = {
    #     fixed-center = false;
    #     # a way to have a manual definition !
    #     include = [ "~/.config/waybar/common.jsonc" ];
    #   };
    # };
  };

  # TODO
  systemd.user.services.waybar = lib.mkIf config.programs.waybar.enable {
    Service = {
      # to get:
      # - fonts https://github.com/nix-community/home-manager/issues/4099#issuecomment-1605483260
      # - nvidia-smi
      Environment = [
        "PATH=$PATH:/etc/profiles/per-user/teto/bin:/run/current-system/sw/bin:${
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
      }:${dotfilesPath}/bin"
      "LC_ALL=ja_JP.utf8"
    ];
    };
    Unit.PartOf = [ "tray.target" ];
    Install.WantedBy = [ "tray.target" ];
  };
}
