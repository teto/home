# inspired by https://nixos.wiki/wiki/GNOME
{ config, lib, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [ 
   gnome.adwaita-icon-theme
   gnomeExtensions.appindicator
  ];

  # as per  https://nixos.wiki/wiki/GNOME/Calendar
  programs.dconf.enable = true;
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  # services.xserver.desktopManager.gnome.enable = true;

  services.gnome.evolution-data-server.enable = false;
  # optional to use google/nextcloud calendar
  services.gnome.gnome-online-accounts.enable = true;
  # optional to use google/nextcloud calendar
  # External calendar such as google/nextcloud can be only added via the gnome-control-center:

  # $ nix-shell -p gnome.gnome-control-center --run "gnome-control-center"

}
