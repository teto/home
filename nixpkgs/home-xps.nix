# home-manager specific config from
{ lib, pkgs,  ... }:
{
  imports = [
    # Include the results of the hardware scan.
    # Not tracked, so doesn't need to go in per-machine subdir
      ./home-common.nix
      # ./mptcp-kernel.nix
      # symlink towards a config
  ];

  home.packages = [
    pkgs.touchegg
  ];
  # we want us,fr !
  # home.keyboard.layout = "fr,us";
  home.keyboard.options = [
    # "grp:caps_toggle" "grp_led:scroll"
  ];

  # does not exist
  # programs.adb.enable = true;

  xsession.initExtra = ''
    xrandr --output  eDP1 --mode 1600x900
    '';


    # TODO add to zsh config
    # . "$ZDOTDIR/transfer.zsh"

}

