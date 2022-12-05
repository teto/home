{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    tagainijisho # japanse dict; like zkanji Qt based

    gnome.gnome-maps
  ];


}
