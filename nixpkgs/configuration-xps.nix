# home-manager specific config from
{ config, lib, touchegg, ... }:
# { pkgs, lib,  ... }:
{

  home.pkgs = [ touchegg ];
  home.keyboard.layout = "fr,us";
  home.keyboard.options = [ 
    # "grp:caps_toggle" "grp_led:scroll" 
  ];
  # home.
  xsession.initExtra = ''
    xrandr --output  eDP1 --mode 1600x900
    '';

}
