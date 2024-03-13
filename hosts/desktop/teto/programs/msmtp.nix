{ config, lib, pkgs, ... }:
{
    
  programs.msmtp = {
    enable = true;
    extraConfig = ''
      # this will create a default account which will then break the
      # default added via primary
      # syslog         on
    '';
  };




}

