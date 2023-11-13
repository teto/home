{ lib, pkgs, ... }:
{
  # https://github.com/rycee/home-manager/pull/829
  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "swaylock"; }
      { event = "lock"; command = "lock"; }
    ];

    # timeout <timeout> <timeout command> [resume <resume command>]
    # Execute timeout command if there is no activity for <timeout> seconds.
    timeouts = [
       { timeout = 60; command = "${pkgs.swaylock}/bin/swaylock -fF"; }
    ];
  };
}
