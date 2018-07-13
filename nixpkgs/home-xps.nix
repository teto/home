# home-manager specific config from
{ config, lib, pkgs,  ... }:
let 

  mbsyncConfig = {
    enable = true;
    # extraConfig = ''
    #   '';

    create = "maildir";
  };
  in
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
  
<<<<<<< HEAD
||||||| merged common ancestors
  accounts.email.accounts = {
    gmail = {

      notmuch.enable = true;
      # name = "gmail";
      primary = true;
      userName = "mattator";
      realName = "Luke skywalker";
      address = "mattator@gmail.com";
      imap = {
        host = "imap.gmail.com";
        # port = 
        # tls = 
      };

      smtp = {
        host = "smtp.gmail.com";
        port =  465 ; # or 25
# Gmail SMTP port (TLS): 587
# Gmail SMTP port (SSL): 465
        # tls = 

      };
      
      # TODO this should be made default
      # maildirModule.path = "gmail";

      # passwordCommand = "secret-tool lookup email me@example.org";
      # maildir = 

      # todo make it optional ?
      # store = home.homeDirectory + ./maildir/gmail;
      # contactCompletion = "notmuch address";
    };

    iij = {
      notmuch.enable = true;
      userName = "coudron@iij.ad.jp";
      realName = "Matthieu Coudron";
      address = "test@testjj.ad.jp";
      imap = { host = "imap-tyo.iiji.jp"; };
      smtp = { host = "mbox.iiji.jp"; };
    #   # getLogin = "";
    #   # getPass = "";
    };

  };
=======
  accounts.email.accounts = {
    gmail = {

      mbsync = mbsyncConfig;
      alot.enable = true;
      notmuch.enable = true;
      offlineimap = {
        enable = true;
        # postSyncHookCommand = ;
      };

      # name = "gmail";
      primary = true;
      userName = "mattator";
      realName = "Luke skywalker";
      address = "mattator@gmail.com";
      imap = {
        host = "imap.gmail.com";
        # port = 
        # tls = 
      };

      smtp = {
        host = "smtp.gmail.com";
        port =  465 ; # or 25
# Gmail SMTP port (TLS): 587
# Gmail SMTP port (SSL): 465
        # tls = 

      };
      
      # TODO this should be made default
      # maildirModule.path = "gmail";

      # passwordCommand = "secret-tool lookup email me@example.org";
      # maildir = 

      # todo make it optional ?
      # store = home.homeDirectory + ./maildir/gmail;
      # contactCompletion = "notmuch address";
    };

    # iij = {
    #   notmuch.enable = true;
    #   userName = "coudron@iij.ad.jp";
    #   realName = "Matthieu Coudron";
    #   address = "test@testjj.ad.jp";
    #   passwordCommand = "";
    #   imap = { host = "imap-tyo.iiji.jp"; };
    #   smtp = { host = "mbox.iiji.jp"; };
    #   # getLogin = "";
    # };

  };
>>>>>>> 3c4582900dc29eb64d7f66386e9c9e77f665474e


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

