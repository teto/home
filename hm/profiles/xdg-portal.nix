{ lib, pkgs, config, ... }:

{
  xdg.portal = {
    enable = true;
    extraPortals = [
     pkgs.xdg-desktop-portal-wlr
     pkgs.xdg-desktop-portal-gtk
     # pkgs.xdg-desktop-portal-kde # too big but might be necessary for flameshot ?
     pkgs.xdg-desktop-portal-gnome # necessary for flameshot
    ];

    # config.hyprland.default = [ "wlr" "gtk" ];
    config.sway.default = [ "wlr" "gtk" ];
  };
}
