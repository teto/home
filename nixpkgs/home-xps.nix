# home-manager specific config from
{ config, lib, pkgs,  ... }:
{
  imports = [
    # Not tracked, so doesn't need to go in per-machine subdir
      ./home-common.nix
      # ./mptcp-kernel.nix
      # symlink towards a config
    ]
    ++ lib.optional (true) ./home-mail.nix
    ;

  # on home-manager master
  # home.accounts.mail.maildirModule
  


  home.packages = with pkgs; [
    # touchegg # won't work anymore apparently
    # libinput-gestures
    rofi
    # netperf # check for man; netserver to start
  ];
  # we want us,fr !
  # home.keyboard.layout = "fr,us";
  home.keyboard.options = [
    # "grp:caps_toggle" "grp_led:scroll"
  ];
  
  # for blue tooth applet; must be installed systemwide
  services.blueman-applet.enable = true;

  programs.bash = {
    # goes to .profile
    enableAutojump = true;
    sessionVariables = {
      # HISTFILE="$XDG_CACHE_HOME/bash_history";
    };
  };

  # does not exist
  # programs.adb.enable = true;

  xsession.initExtra = ''
    xrandr --output  eDP1 --mode 1600x900
    '';

  programs.fzf = {
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    # dotDir = ".config/zsh";
    sessionVariables = {
      # HISTFILE="$XDG_CACHE_HOME/zsh_history";
    };
    history.save = 10000;
    history.ignoreDups = true;
    history.path = "$XDG_CACHE_HOME/zsh_history";
    history.share = true;
    history.size = 10000;
    shellAliases = {
    } // config.programs.bash.shellAliases;
    # plugins = 
    # loginExtra=
    initExtra = ''
      alias -s html=qutebrowser
      alias -s json=nvim
      alias -s Vagrantfile=nvim
      alias -s png=sxiv
      alias -s jpg=xdg-open
      alias -s gif=xdg-open
      alias -s avi=mpv
      alias -s mp3=mocp
      alias -s pdf=xdg-open
      alias -s doc=xdg-open
      alias -s docx=xdg-open

      source ${pkgs.autojump}/share/autojump/autojump.zsh

      # VERY IMPORTANT else zsh can eat last line
      setopt prompt_sp
      source $ZDOTDIR/zshrc
    '';
  };

    # TODO add to zsh config
    # . "$ZDOTDIR/transfer.zsh"

}

