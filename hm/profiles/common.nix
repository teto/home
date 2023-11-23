{ config, pkgs, lib, ... }:
{
  news.display = "silent";

  imports = [

    ./shell.nix
    ./git.nix
    ./zsh.nix

    # the module is a pain
    # ./xdg-mime.nix
  ];

  xdg.mime.enable = true;

  # home.extraOutputsToInstall = [ "man" "doc" ];
  programs.man.enable = true;

  home.packages = with pkgs; [

    # TODO try i3-snapshot
    # hstr # to deal with shell history
    # or lazygit
    nix-prefetch-git
    netcat-gnu # plain 'netcat' is the bsd one
    # nvimpager # 'less' but with neovim
    strace
    tailspin  #  a log viewer based on less ("spin" or "tsspin" is the executable)
    tig
    xdg-utils
    wttrbar # for meteo
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

  home.stateVersion = "24.05";

  # - https://github.com/carnager/rofi-scripts.git
  # https://github.com/carnager/buku_run
  home.sessionVariables = {
    # RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/rg.conf";
    ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
    INPUTRC = "$XDG_CONFIG_HOME/inputrc";

    # TODO package these instead now these are submoudles of dotfiles To remove
    VIFM = "$XDG_CONFIG_HOME/vifm";
    WWW_HOME = "$XDG_CONFIG_HOME/w3m";
    # used by ranger
    TERMCMD = "kitty";
    # TERMINAL # used by i3-sensible-terminal
  };

  # source file name can't start with .
  # home.file.".wgetrc".source = dotfiles/home/wgetrc;

  xdg = {
    enable = true;
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

  # home.activation.copyZshrc = dagEntryBefore [ "linkGeneration" ] ''
  #   cp $
  #   '';

  # for colors etc.
  programs.lesspipe.enable = true;

}
