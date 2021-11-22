{ config, pkgs, lib,  ... }:
{

  home.packages = with pkgs; [
    # grimshot # simplifies usage of grim ?
    clipman  # clipboard manager, works with wofi
    foot  # terminal
    grim  # replace scrot
    kanshi  # autorandr-like
    wofi  # rofi-like
    slurp  # capture tool
    # wf-recorder # for screencasts
    # bemenu as a dmenu replacement
    waybar  # just for testing
    wdisplays
    #  wallutils  # to set wallpaper
    wl-clipboard # wl-copy / wl-paste
    wdisplays # to show 
    wlogout  # a logout menu
    # xdg-desktop-portal-wlr
    wob # to display a progressbar
  ];

}
