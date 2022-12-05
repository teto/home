{ config, pkgs, lib, ... }:
{
  # there is also dunst

  home.packages = [
    pkgs.deadd-notification-center
  ];

}

