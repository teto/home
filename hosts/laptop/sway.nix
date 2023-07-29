{ config, lib, pkgs, ... }:
{

  wayland.windowManager.sway = {
    enable = true;

    extraSessionCommands = lib.mkForce "";
    extraOptions = [
      "--verbose"
      "--debug"
    ];
  };


}
