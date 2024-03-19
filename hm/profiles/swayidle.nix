{ lib, pkgs, ... }:
{
  # https://github.com/rycee/home-manager/pull/829
  services.swayidle = {
    enable = true;

    timeouts = [
     # timeout in seconds
     { timeout = 300; 
       command="swaymsg 'output * dpms off'"; 
       resumeCommand = "swaymsg 'output * dpms on'";
     }
    ];
    
    events = [
      { event = "before-sleep"; command = "swaylock"; }
      { event = "lock"; command = "lock"; }
    ];
  };
}
