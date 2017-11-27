# home-manager specific config from
{ config, lib, pkgs, ... }:
# { pkgs, lib,  ... }:
{

  home.packages = [ pkgs.touchegg ];
  # home.keyboard.layout = mkBefore "fr,us";
  home.keyboard.options = [ 
    # "grp:caps_toggle" "grp_led:scroll" 
  ];
  # home.
  xsession.initExtra = ''
    xrandr --output  eDP1 --mode 1600x900
    '';

}
