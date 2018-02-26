# home-manager specific config from
{ lib, pkgs,  ... }:
{
  imports = [
    # Not tracked, so doesn't need to go in per-machine subdir
      ./home-common.nix
      # ./mptcp-kernel.nix
      # symlink towards a config
  ];

  home.packages = with pkgs; [
    touchegg
    rofi
  ];
  # we want us,fr !
  # home.keyboard.layout = "fr,us";
  home.keyboard.options = [
    # "grp:caps_toggle" "grp_led:scroll"
  ];

  programs.bash = {
    # goes to .profile
    sessionVariables = {
      # HTTP_PROXY="http://
      # HISTFILE="$XDG_CACHE_HOME/bash_history";
    };

  # does not exist
  # programs.adb.enable = true;

  xsession.initExtra = ''
    xrandr --output  eDP1 --mode 1600x900
    '';


    # TODO add to zsh config
    # . "$ZDOTDIR/transfer.zsh"

}

