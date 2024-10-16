{
  lib,
  pkgs,
  config,
  ...
}:

{
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
      # big but might be necessary for flameshot ? and nextcloud-client
      pkgs.xdg-desktop-portal-kde 
      pkgs.xdg-desktop-portal-gnome # necessary for flameshot
    ];

    # config.hyprland.default = [ "wlr" "gtk" ];
    config.sway.default = [
      "wlr"
      "gtk"
    ];
  };
}
