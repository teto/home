{ config, pkgs, lib, ... }:
{

 # TODO it is done in sway.nix
  home.packages = with pkgs; [
  #   clipman # clipboard manager, works with wofi
  #   foot # terminal
  #   grim # replace scrot
  #   kanshi # autorandr-like
  #   wofi # rofi-like
  #   slurp # capture tool
  #   wf-recorder # for screencasts
  #   # bemenu as a dmenu replacement
  #   wdisplays
  #   wl-clipboard # wl-copy / wl-paste
  #   wdisplays # to show 
  #   wlogout # a logout menu
    waypaper # sets wallpapers
  ];

  # TODO export sway's extraSessionCommands
 # MOZ_ENABLE_WAYLAND=1 
}
