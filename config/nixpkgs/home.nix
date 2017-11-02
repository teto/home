{ pkgs, ... }:

let
  # the kind of packages u don't want to compile
  # TODO les prendres depuis un channel avec des binaires ?
  heavyPackages = with pkgs;[
          libreoffice
          qutebrowser
          gnome3.nautilus # demande webkit
          mendeley # requiert qtwebengine
          pinta
          qtcreator
          zeal
          zotero
        # astroid # always compiles webkit so needs 1 full day
  ];
  desktopPkgs = with pkgs; [
          buku
          dropbox
          ffmpegthumbnailer # to preview videos in ranger
          haskellPackages.greenclip # todo get from haskell
          nox
          # gnome3.gnome_control_center
          qtpass
          sublime3
          scrot
          system_config_printer
          transmission_gtk
          translate-shell
          w3m # for preview in ranger w3mimgdisplay
          xorg.xev
          xclip
          zathura
  ];
  devPkgs = with pkgs; [
          editorconfig-core-c
          exa
          gdb
          gitAndTools.git-extras
          mypy
          # neovim
          neovim-remote
          nix-prefetch-scripts
          nix-repl
          nix-index
          python3Packages.neovim
          python3Packages.pycodestyle
          rpl
          universal-ctags
          ];
    imPkgs = with pkgs; [
        offlineimap # python 2 only
        # python27Packages.alot # python 2 only
        khal
        khard
        # msmtp
        newsbeuter
        notmuch
        slack
        vdirsyncer
        weechat
        # leafnode dovecot22 dovecot_pigeonhole fetchmail procmail w3m
        # mairix mutt msmtp lbdb contacts spamassassin
      ];
      # TODO add heavyPackages only if available ?
      # or set binary-cache
    # nixos= import '<nixos-unstable>' 
in
{
  home.packages = desktopPkgs ++ devPkgs ++ imPkgs;

  # programs.emacs = {
  #   enable = true;
  #   extraPackages = epkgs: [
  #     epkgs.nix-mode
  #     epkgs.magit
  #   ];
  # };
  # programs.rofi = {
  #   enable = true;
  # };

  # TODO doesn't find ZDOTDIR (yet)
  # TODO maybe we can add to PATH 
  # - https://github.com/carnager/rofi-scripts.git
  # https://github.com/carnager/buku_run
  home.sessionVariables = {

    WEECHAT_HOME="$XDG_CONFIG_HOME/weechat";
    TIGRC_USER="$XDG_CONFIG_HOME/tig/tigrc";
    LESSHISTFILE="$XDG_CACHE_HOME/less/history";
    NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch/notmuchrc";
    INPUTRC="$XDG_CONFIG_HOME/inputrc";
    IPYTHONDIR="$XDG_CONFIG_HOME/ipython";
    JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter";
    # testing if we can avoid having to symlink XDG_CONFIG_HOME
    XDG_CONFIG_DIRS="$XDG_CONFIG_HOME:$HOME/dotfiles";
    # PATH+=":$HOME/rofi-scripts";
    MUTT="$XDG_CONFIG_HOME/mutt";
    MAILDIR="$HOME/Maildir";
    PATH="$HOME/rofi-scripts:$HOME/buku_run:$PATH";

  };
  # home.folder.".wgetrc".source = dotfiles/home/.wgetrc;

  programs.home-manager = {
    enable = true;
    # path = https://github.com/rycee/home-manager/archive/master.tar.gz;
    # failshome.folder +
    # path =  /home/teto/dotfiles;
  };

  # programs.termite

  xdg = {
    enable = true;
    configFile."nvim/toto".text = ''
      hello world
    '';
  };
  # xdg.configFile.".config/mpv/input.conf".source = dotfiles/mpv-input.conf;
  # xdg.configFile.".config/mpv/mpv.conf".source = dotfiles/mpv-mpv.conf;

  programs.bash = {
    enable = true;
    enableAutojump = true;
    sessionVariables = {
      HISTFILE="$XDG_CACHE_HOME/bash_history";
    };
    shellAliases = {
      hm="home-manager";
      #mostly for testin
      dfh="df --human-readable";
      duh="du --human-readable";
    };
  };

  # programs.zsh = {
  #   enable = true;
  #   sessionVariables = {
  #     HISTFILE="$XDG_CACHE_HOME/zsh_history";
  #   };
  #   shellAliases = {
  #   nixpaste="curl -F 'text=<-' http://nixpaste.lbr.uno";
  #   };
  # };

  # programs.git = {
    #   enable = true;
    #   userName = "Jane Doe";
    #   userEmail = "jane.doe@example.org";
    # };

  # tray is enabled by default
  services.udiskie = {
    enable = true;
    notify = false;
    automount = false;
  };

  # TODO prefix with stable
  # programs.firefox = {
  #   enable = true;
  #   enableAdobeFlash = true;
  # };

  programs.neovim = {
    enable = true;
    vimAlias = false;
    withPython3 = true;
    withPython = false;
    withRuby = false;
    extraPython3Packages = with pkgs.python3Packages;[ pandas python jedi]
      ++ super.stdenv.lib.optionals ( python-language-server != null) [ python-language-server ]


      ;
    extraConfig = ''
      " TODO set different paths accordingly, to language server especially
      '';
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

  # todo configure mocp
  # todo configure neovim
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  # services.xserver.enable = true;

  # i3 now available !
  xsession.enable = true;
  # xsession.windowManager.command = "…";

  # as long as there is no better way to configure i3
  xsession.windowManager.command = "${pkgs.i3}/bin/i3";
}
