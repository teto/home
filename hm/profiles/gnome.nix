{ config, lib, pkgs, ... }:
{

  home.packages = with pkgs; [
    # need gnome-accounts to make it work
    gnome3.gnome-calendar


  ];
}
