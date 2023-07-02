{ config, lib, pkgs, ... }:
{
  # necessary to be able to share screens (not sure why ...)
  xdg.portal = {
    wlr.enable = true;
    lxqt.enable = true;
    # xdg-desktop-portal-gnome
    extraPortals = [
        # pkgs.xdg-desktop-portal-gnome # necessary for flameshot
        pkgs.xdg-desktop-portal-kde
        # (pkgs.xdg-desktop-portal-gtk.override {
        #   # Do not build portals that we already have.
        #   buildPortalsInGnome = false;
        # })
      ];

  };
}
