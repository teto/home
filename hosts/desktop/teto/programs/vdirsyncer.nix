{ config, lib, pkgs, ... }:
{
  programs.vdirsyncer = {
    enable = false;
    # Provide package from stable channel ?
    # package = pkgs.vdirsyncerStable;  

  };
}
