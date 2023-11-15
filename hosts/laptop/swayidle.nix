{ config, lib, pkgs, ... }:
{

  services.swayidle = {

    # timeout <timeout> <timeout command> [resume <resume command>]
    # Execute timeout command if there is no activity for <timeout> seconds.
    timeouts = [
       { timeout = 60; command = "${pkgs.swaylock}/bin/swaylock -fF"; }
    ];
 };
}

