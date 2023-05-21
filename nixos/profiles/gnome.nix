# inspired by https://nixos.wiki/wiki/GNOME
{ config, lib, pkgs, ... }:
{

  # home.packages = with pkgs; [
  #   # need gnome-accounts to make it work
  #   gnome3.gnome-calendar

  environment.systemPackages = with pkgs; [ 
   gnome.adwaita-icon-theme
   gnomeExtensions.appindicator
  ];

  # ];

  # as per  https://nixos.wiki/wiki/GNOME/Calendar
  programs.dconf.enable = true;
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

    services.gnome.evolution-data-server.enable = true;
  # optional to use google/nextcloud calendar
  services.gnome.gnome-online-accounts.enable = true;
  # optional to use google/nextcloud calendar
  services.gnome.gnome-keyring.enable = true;
  # External calendar such as google/nextcloud can be only added via the gnome-control-center:

  # $ nix-shell -p gnome.gnome-control-center --run "gnome-control-center"

}
