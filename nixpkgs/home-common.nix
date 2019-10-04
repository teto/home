{ config, pkgs, lib,  ... } @ args:
let
  stable = import <nixos> {};
  unstable = import <nixos-unstable> {};

  cliUtils = with pkgs; [
    netcat-gnu # plain 'netcat' is the bsd one
    bind # for dig
    w3m # for preview in ranger w3mimgdisplay
    xdg_utils
  ];

in
rec {
  news.display = "silent";

  # home.extraOutputsToInstall = [ "man" "doc" ];
  programs.man.enable = true;

  home.packages = with pkgs; [
    # TODO pass to vim makeWrapperArgs
    pkgs.nodePackages.bash-language-server
    # just in my branch :'(
    pkgs.luaPackages.lua-lsp

    # to be used in i3
    # pkgs.i3dispatch
  ];

  # works only because TIGRC_USER is set
  # if file exists vim.tigrc
  home.file."${config.xdg.configHome}/tig/config".text = let
    vimTigrc = "${pkgs.tig}/etc/vim.tigrc";
  in
    ''
      source ${pkgs.tig}/etc/vim.tigrc
      # not provided
      # source ${pkgs.tig}/tig/contrib/large-repo.tigrc
      source ${config.xdg.configHome}/tig/custom.tigrc
    '';
  # lib.concatStrings [
  #   (builtins.readFile vimTigrc)
  #   # TODO reestablish when the package gets updated
  #   # (builtins.readFile "${pkgs.tig}/tig/contrib/large-repo.tigrc")
  #   (builtins.readFile ../large-repo.tigrc)
  # ];


  # home.file.".gdbinit".source = ../config/gdbinit_simple;
  home.file.".gdbinit".text = ''
    # ../config/gdbinit_simple;
    # gdb doesn't accept environment variable except via python
    source ${config.xdg.configHome}/gdb/gdbinit_simple
    set history filename ${config.xdg.cacheHome}/gdb_history
  '';

  # home.file."${config.xdg.configHome}/rg.conf".text = ''
  # '';

  # home.file.".ghc/ghci.conf".source = ../home/ghci.conf;

  # useful to prevent some problems with nix
  # https://github.com/commercialhaskell/stack/issues/2358
  home.file.".stack/config.yaml".source = ../home/stack.yaml;

  # see tips/haskell.md, an incomplete cabal config can be a pain
  # - absence of repostiory will make cabal update fail
  # is needed with new-build ?
  # "nix: True";
  # home.file.".cabal/config".text = ../home/cabal;


  # TODO doesn't find ZDOTDIR (yet)
  # TODO maybe we can add to PATH
  # TODO use xdg.configFile ?
  # - https://github.com/carnager/rofi-scripts.git
  # https://github.com/carnager/buku_run
  home.sessionVariables = {
    # RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/rg.conf";
    ZDOTDIR="$XDG_CONFIG_HOME/zsh";
    WEECHAT_HOME="$XDG_CONFIG_HOME/weechat";
    INPUTRC="$XDG_CONFIG_HOME/inputrc";
    IPYTHONDIR="$XDG_CONFIG_HOME/ipython";
    JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter";
    # testing if we can avoid having to symlink XDG_CONFIG_HOME
    # should be setup by neomutt module
    # MUTT="$XDG_CONFIG_HOME/mutt";

    # TODO package these instead now these are submoudles of dotfiles To remove
    PATH="$HOME/rofi-scripts:$HOME/buku_run:$PATH";
    VIFM="$XDG_CONFIG_HOME/vifm";
    WWW_HOME="$XDG_CONFIG_HOME/w3m";
    # used by ranger
    TERMCMD="termite";
    # TERMINAL # used by i3-sensible-terminal
  };

  # TODO
  # (import <nixpkgs/nixos> {}).config
  # systemd.user.sessionVariables = args.nixos.config.networking.proxy.envVars;

  # source file name can't start with .
  # home.file.".wgetrc".source = dotfiles/home/wgetrc;

  xdg = {
    enable = true;
    # configFile."nvim/toto".text = ''
    #   hello world
    # '';
  };

  # xdg.configFile.".config/mpv/input.conf".source = dotfiles/mpv-input.conf;
  # xdg.configFile.".config/mpv/mpv.conf".source = dotfiles/mpv-mpv.conf;

  programs.bash = {
    enable = true;
    enableAutojump = true;

    # goes to .profile
    sessionVariables = {
      HISTTIMEFORMAT="%d.%m.%y %T ";
      # HISTFILE="$XDG_CACHE_HOME/bash_history";
    };
    # historyControl=["erasedups", "ignoredups", "ignorespace"]
    historyIgnore=["ls"];
    # historyFile = "${xdg.cacheHome}/bash_history";
    historyFile = "$XDG_CACHE_HOME/bash_history";
    # initExtra=''
    #   ${includeFzf}
    # '';
      # profileExtra=''
      #   '';
      # shellOptions=
    shellAliases = {
      hm="home-manager";
      #mostly for testin
      dfh="df --human-readable";
      duh="du --human-readable";
      latest="ls -lt |head";
      fren="trans -from fr -to en ";
      enfr="trans -from en -to fr ";
      jpfr="trans -from ja -to fr ";
      frjp="trans -from fr -to ja ";
      jpen="trans -from ja -to en ";
      enjp="trans -from en -to ja ";
      dmesg="dmesg --color=always|less";

      tcp_netstat="netstat -ltnp";
      # TODO move to root level ?
      nixpaste="curl -F \"text=<-\" http://nixpaste.lbr.uno";

      # kitty
      icat="kitty +kitten icat";

      # modprobe to use 
      # TODO might need to use -S as well
      modprobe_exp="modprobe -d /home/teto/mptcp/build";
    };


  };


  programs.git = {
    enable = true;
    # use accounts.email ?
    # load it from secrets ?
    package = pkgs.gitAndTools.gitFull;    # to get send-email
    userName = "Matthieu Coudron";
    userEmail = "coudron@iij.ad.jp";
	includes = [
	  { path = config.xdg.configHome + "/git/config.inc"; }
	];

    # https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work
    signing = {
      signByDefault = false;
      key = "64BB6787";
    };

    extraConfig= {
      rebase = {
        autosquash = true;
        autoStash = true;
      };

      pull = {
        rebase = true;
      };

      stash = {
          showPatch = 1;
      };
      color = {
        ui = true;
      };

      pager = {
        # diff-so-fancy | less --tabs=1,5 -RFX
        diff = "${pkgs.gitAndTools.diff-so-fancy}/bin/diff-so-fancy | less --tabs=1,5 -RFX";
        show = "${pkgs.gitAndTools.diff-so-fancy}/bin/diff-so-fancy | less --tabs=1,5 -RFX";
      };

    # pager = {
	# diff = diff-so-fancy | less --tabs=1,5 -RFX
	# show = diff-so-fancy | less --tabs=1,5 -RFX
  # };
    };
  };

  # programs.neovim = {
  #   enable = true;
  #   withPython3 = true;
  #   withPython = false;
  # };

  # home.activation.setXDGbrowser = dagEntryBefore [ "linkGeneration" ] ''
  # xdg-settings set default-web-browser firefox.desktop

  programs.starship = {
    enable = true;
  };

  programs.vim = {
    enable = true;
    settings = {
      number = true;
    };
    extraConfig = ''
      " TODO set different paths accordingly, to language server especially
      '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration=true;
    # defaultOptions
    # changeDirWidgetOptions
    # programs.fzf.fileWidgetOptions
    # programs.fzf.historyWidgetOptions
  };

  # xresources.properties = {
  # };

  # home.file.".latexmkrc".text =  ''
  #   $bibtex="${texliveEnv}/bin/bibtex"
  #   # c'est du perl à priori
  #   $pdflatex = 'pdflatex -shell-escape -file-line-error -synctex=1 %O %S';
  #   # How to make the PDF viewer update its display when the PDF file changes.  See the man page for a description of each method.
  #   # $pdf_update_method = 2;
  #   # When PDF update method 2 is used, the number of the Unix signal to send
  #   # $pdf_update_signal = 'SIGHUP';
  # '';

  # qt = {
  #   enable = true;
  #   platformTheme = "gnome";
  # };

  programs.zsh = rec {
    enable = true;
    # dotDir = "${config.xdg.configHome}/zsh";
    dotDir = ".config/zsh";
    sessionVariables = {
      # HISTFILE="$XDG_CACHE_HOME/zsh_history";
    };
    history = {
        save = 10000000;
        ignoreDups = true;
        # defined as HISTFILE="$HOME/${cfg.history.path}"
        # https://github.com/nsnam/bake-git
        # TODO fix
        path = ".cache/zsh_history";
        share = true;
        extended = true; # save timestamp
    };
    shellAliases = {
    } // config.programs.bash.shellAliases;

    autocd = true;
    # plugins =
    # loginExtra=
    # profileExtra
    initExtra = ''
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


      # there must be a module for this
      source ${pkgs.autojump}/share/autojump/autojump.zsh

      # VERY IMPORTANT else zsh can eat last line
      setopt prompt_sp

      # used to compile bpf stuff
      __bcc() {
              clang -O2 -emit-llvm -c $1 -o - | \
              llc -march=bpf -filetype=obj -o "`basename $1 .c`.o"
      }

      # TODO remove and include it ?
      # source $ZDOTDIR/zshrc.generated
      source $ZDOTDIR/zshrc


    ''
    # eval "$(${pkgs.starship}/bin/starship init zsh)"
      # + builtins.readFile dotDir + ./zshrc
      ;

  };

  programs.tmux = {
    enable = true;
    sensibleOnTop = true;
    secureSocket = false;
    # tmuxinator.enable = false;
    # tmuxp

    # see if we can't get https://github.com/tmux-plugins/vim-tmux-focus-events in
    # plugins = with pkgs; [
    #              tmuxPlugins.cpu
    #              {
    #                plugin = tmuxPlugins.resurrect;
    #                extraConfig = "set -g @resurrect-strategy-nvim 'session'";
    #              }
    #              {
    #                plugin = tmuxPlugins.continuum;
    #                extraConfig = ''
    #                  set -g @continuum-restore 'on'
    #                  set -g @continuum-save-interval '60' # minutes
    #                '';
    #              }
    #            ];

    extraConfig = ''
      # ----------------------
      # Status Bar
      # -----------------------
      set-option -g status on                # turn the status bar on
      if-shell -b 'head $XDG_CONFIG_HOME/tmux/config' \
        "source-file $XDG_CONFIG_HOME/tmux/config"
      '';
  };

  xdg.configFile."zsh/zshrc.generated".source = ../config/zsh/zshrc;
  # home.activation.copyZshrc = dagEntryBefore [ "linkGeneration" ] ''
  #   cp $
  #   '';
  home.file.".digrc".source =  ../home/digrc;

  # order matters
  home.file.".mailcap".text =  ''
applmcation/pdf; evince '%s';
# pdftotext
# wordtotext
# ppt2text
# download script mutt_bgrun
#application/pdf; pdftohtml -q -stdout %s | w3m -T text/html; copiousoutput
#application/msword; wvWare -x /usr/lib/wv/wvHtml.xml %s 2>/dev/null | w3m -T text/html; copiousoutput
text/calendar; khal import '%s'
text/*; less '%s';
# khal import [-a CALENDAR] [--batch] [--random-uid|-r] ICSFILE
image/*; eog '%s';

    text/html;  ${pkgs.w3m}/bin/w3m -dump -o document_charset=%{charset} '%s'; nametemplate=%s.html; copiousoutput
    application/*; xdg-open "%s"
    */*; xdg-open "%s"
  '';

  # for colors etc.
  programs.lesspipe.enable = true;

  manual.json.enable = true;

}
