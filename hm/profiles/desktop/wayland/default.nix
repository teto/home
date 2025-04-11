{ config, lib, pkgs, ... }:
{
  windowManager.sway = {  
    enable = true;
    xwayland = false;
    systemd.enable = true;
    systemd.variables =  [ "PATH" ];


    # disabling swayfx until  those get merged
    # https://github.com/nix-community/home-manager/pull/4039
    # https://github.com/NixOS/nixpkgs/pull/237044
    # be careful as this can override default options
    # package = pkgs.swayfx;
    # package = pkgs.sway-unwrapped;

    checkConfig = false;
  };
}
