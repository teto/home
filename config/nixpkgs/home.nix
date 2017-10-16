{ pkgs, ... }:

let
  # extraPackages = with pkgs; [
  #   alacritty
  #   ];
  desktopPkgs = with pkgs; [
          buku
          dropbox
          gnome3.nautilus
          ffmpegthumbnailer # to preview videos in ranger
          haskellPackages.greenclip # todo get from haskell
          libreoffice
          mendeley
          nox
          # gnome3.gnome_control_center
          pinta
          qtpass
          qutebrowser
          qtcreator
          sublime3
          scrot
          system_config_printer
          transmission_gtk
          translate-shell
          w3m # for preview in ranger w3mimgdisplay
          xorg.xev
          xclip
          zathura
          zotero
          zeal
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
          pstree
          rpl
          slack
          universal-ctags
          ];
    imPkgs = with pkgs; [
        # astroid
        offlineimap # python 2 only
        # python27Packages.alot # python 2 only
        khal
        khard
        msmtp
        newsbeuter
        notmuch
        slack
        vdirsyncer
        weechat
        # leafnode dovecot22 dovecot_pigeonhole fetchmail procmail w3m
        # mairix mutt msmtp lbdb contacts spamassassin
      ];
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
    # PATH+=":$HOME/rofi-scripts";
    MUTT="$XDG_CONFIG_HOME/mutt";
    MAILDIR="$HOME/Maildir";
    PATH="$HOME/rofi-scripts:$HOME/buku_run:$PATH";

  };

  programs.bash = {
    enable = true;
    enableAutojump = true;
    sessionVariables = {
      HISTFILE="$XDG_CACHE_HOME/bash_history";
    };
    shellAliases = {
      #mostly for testin
      dfh="df --human-readable";
      duh="du --human-readable";
    };
  };

  programs.zsh = {
    enable = true;
    sessionVariables = {
      HISTFILE="$XDG_CACHE_HOME/zsh_history";
    };
    shellAliases = {
    nixpaste="curl -F 'text=<-' http://nixpaste.lbr.uno";
    };
  };

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
  # programs.firefox = {
  #   enable = true;
  #   enableAdobeFlash = true;
  # };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}
