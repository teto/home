{ config, lib, pkgs, ... }:
{

  # for android development
  programs.light = {
    enable = true;
    brightnessKeys = true;  # custom patch
  };
}


