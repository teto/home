{ config, pkgs, lib, ... }:
{
  news.display = "silent";

  imports = [

    ./shell.nix
    ./git.nix

    # the module is a pain
    # ./xdg-mime.nix
  ];

  xdg.mime.enable = true;

  home.username = "teto";
  home.homeDirectory = "/home/teto";

  # home.extraOutputsToInstall = [ "man" "doc" ];
  programs.man.enable = true;

  home.packages = with pkgs; [

    # TODO try i3-snapshot
    # hstr # to deal with shell history
    envsubst
    # or lazygit
    nix-prefetch-git
    netcat-gnu # plain 'netcat' is the bsd one
    # nvimpager # 'less' but with neovim
    # dig.dnsutils  # for dig disabled because of flakes
    perf-tools
    strace
    tig
    w3m # for preview in ranger w3mimgdisplay
    xdg-utils
    whois
  ];

  # works only because TIGRC_USER is set
  # if file exists vim.tigrc
  home.file."${config.xdg.configHome}/tig/config".text = ''
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


  home.file.".gdbinit".text = ''
    # ../config/gdbinit_simple;
    # gdb doesn't accept environment variable except via python
    source ${config.xdg.configHome}/gdb/gdbinit_simple
    set history filename ${config.xdg.cacheHome}/gdb_history
  '';

  # useful to prevent some problems with nix
  # https://github.com/commercialhaskell/stack/issues/2358
  # home.file.".stack/config.yaml".source = ../home/stack.yaml;

  home.stateVersion = "23.05";

  # - https://github.com/carnager/rofi-scripts.git
  # https://github.com/carnager/buku_run
  home.sessionVariables = {
    # RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/rg.conf";
    ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
    INPUTRC = "$XDG_CONFIG_HOME/inputrc";
    IPYTHONDIR = "$XDG_CONFIG_HOME/ipython";
    JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
    # testing if we can avoid having to symlink XDG_CONFIG_HOME
    # should be setup by neomutt module
    # MUTT="$XDG_CONFIG_HOME/mutt";

    # TODO package these instead now these are submoudles of dotfiles To remove
    VIFM = "$XDG_CONFIG_HOME/vifm";
    WWW_HOME = "$XDG_CONFIG_HOME/w3m";
    # used by ranger
    TERMCMD = "kitty";
    VIM_SOURCE_DIR = "$HOME/vim";
    # TERMINAL # used by i3-sensible-terminal
  };

  # source file name can't start with .
  # home.file.".wgetrc".source = dotfiles/home/wgetrc;

  xdg = {
    enable = true;
  };

  programs.autojump = {
    enable = false;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
  programs.z-lua = {
    enable = false;
    enableZshIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    options = [ "--cmd j" ];
  };


  # you can switch from cli with xkb-switch or xkblayout-state
  # set to null to disable
  home.keyboard = {
    layout = "fr,us";
    # grp:alt_shift_toggle,ctrl:nocaps,grp_led:scroll
    options = [
      "add Mod1 Alt_R"
      "ctrl:nocaps" # makes caps lock an additionnal ctrl
    ];
  };


  # xdg-settings set default-web-browser firefox.desktop

  # don't enable it since it will override my zle-keymap-select binding
  programs.starship = {
    enable = lib.mkForce true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    # settings = {};
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
    enableZshIntegration = true;
    # so that fzf takes into account .gitignore
    defaultCommand = "${pkgs.fd}/bin/fd --type f";

    # add support for ctrl+o to open selected file in VS Code
    defaultOptions = [ "--bind='ctrl-o:execute(code {})+abort'" ];
    # Setting fd as the default source for fzf
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


  programs.tmux = {
    enable = true;
    sensibleOnTop = true;
    # secureSocket = false;
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

  xdg.configFile."zsh/zshrc.generated".source = ../../config/zsh/zshrc;
  # home.activation.copyZshrc = dagEntryBefore [ "linkGeneration" ] ''
  #   cp $
  #   '';
  # home.file.".digrc".source =  ../../home/digrc;

  # order matters
  home.file.".mailcap".text = ''
    application/pdf; evince '%s';
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

  # TODO
  manual.json.enable = false;
}
