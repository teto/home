# home-manager specific config from
{ lib, touchegg,  ... }:
{
  imports = [
    # Include the results of the hardware scan.
    # Not tracked, so doesn't need to go in per-machine subdir
      ./passwd.nix
      # ./mptcp-kernel.nix
      # symlink towards a config
  ];

  home.pkgs = [ touchegg ];
  # we want us,fr !
  # home.keyboard.layout = "fr,us";
  home.keyboard.options = [
    # "grp:caps_toggle" "grp_led:scroll"
  ];

  programs.adb.enable = true;

  xsession.initExtra = ''
    xrandr --output  eDP1 --mode 1600x900
    '';


    # TODO add to zsh config
    # . "$ZDOTDIR/transfer.zsh"

}

