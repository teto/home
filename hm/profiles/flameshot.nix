{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.flameshot = {
    enable = true;
    # package = pkgs.flameshotGrim;
  };

  systemd.user.services.flameshot.Service = {
    # environment.NEXTCLOUD_CONFIG_DIR = "${datadir}/config";
    # Environment= {
    #   SDL_VIDEODRIVER="wayland";
    #   _JAVA_AWT_WM_NONREPARENTING="1";
    #  QT_QPA_PLATFORM="wayland";
    #  XDG_CURRENT_DESKTOP="sway";
    #  XDG_SESSION_DESKTOP="sway";
    # };
    Environment = [
      "SDL_VIDEODRIVER=wayland"
      "_JAVA_AWT_WM_NONREPARENTING=1"
      "QT_QPA_PLATFORM=wayland"
      "XDG_CURRENT_DESKTOP=sway"
      "XDG_SESSION_DESKTOP=sway"
    ];
  };
}
