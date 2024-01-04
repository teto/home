{ lib, pkgs, config, ... }:

{
  xdg.portal = {
    enable = true;
    extraPortals = [
     pkgs.xdg-desktop-portal-wlr
     pkgs.xdg-desktop-portal-gtk
     pkgs.xdg-desktop-portal-kde
    ];

    # config.hyprland.default = [ "wlr" "gtk" ];
    config.sway.default = [ "wlr" "gtk" ];
  };
}
