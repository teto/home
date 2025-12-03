{ config, lib, pkgs, ... }:
{
  
  programs.msmtp = {
    enable = true;
    accounts = {};
  };
}
