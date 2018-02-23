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

  # does not exist
  # programs.adb.enable = true;

  xsession.initExtra = ''
    xrandr --output  eDP1 --mode 1600x900
    '';

  programs.zsh = {
    enable = true;
    # dotDir =
    sessionVariables = {
      HISTFILE="$XDG_CACHE_HOME/zsh_history";
    };
    shellAliases = {
    nixpaste="curl -F 'text=<-' http://nixpaste.lbr.uno";
    };
  };

    # TODO add to zsh config
    # . "$ZDOTDIR/transfer.zsh"

}

