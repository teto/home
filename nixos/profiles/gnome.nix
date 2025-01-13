# inspired by https://nixos.wiki/wiki/GNOME
{
  config,
  lib,
  pkgs,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    gnomeExtensions.appindicator
  ];

  # as per  https://nixos.wiki/wiki/GNOME/Calendar
  programs.dconf.enable = true;
  services.udev.packages = [ pkgs.gnome-settings-daemon ];

  # services.xserver.desktopManager.gnome.enable = true;

  services.gnome.evolution-data-server.enable = lib.mkForce false;
  # optional to use google/nextcloud calendar
  services.gnome.gnome-online-accounts.enable = true;

  # consumes quite a bit of CPU 
  services.gnome.localsearch.enable = false;

  # optional to use google/nextcloud calendar
  # External calendar such as google/nextcloud can be only added via the gnome-control-center:

  # read the doc at https://nixos.wiki/wiki/GNOME

  # $ nix-shell -p gnome.gnome-control-center --run "gnome-control-center"
  # services.xserver = {
  #   enable = true;
  #   # displayManager.gdm.enable = true;
  #   desktopManager.gnome.enable = true;
  # };
  # environment.gnome.excludePackages = (with pkgs; [
  #   gnome-photos
  #   gnome-tour
  #   gedit # text editor
  # ]) ++ (with pkgs.gnome; [
  #   cheese # webcam tool
  #   gnome-music
  #   gnome-terminal
  #   epiphany # web browser
  #   geary # email reader
  #   evince # document viewer
  #   gnome-characters
  #   totem # video player
  #   tali # poker game
  #   iagno # go game
  #   hitori # sudoku game
  #   atomix # puzzle game
  # ]);
}
