{ pkgs, ... }:

let
  desktopPkgs = with pkgs; [
          buku
          dropbox
          haskellPackages.greenclip # todo get from haskell
          libreoffice
          mendeley
          gnome3.nautilus
          # gnome3.gnome_control_center
          scrot
          transmission_gtk
          translate-shell
          qtpass
          qutebrowser
          xorg.xev
          xclip
          zathura
          zotero
          qtcreator
          zeal
  ];
  devPkgs = with pkgs; [
          editorconfig-core-c
          gdb
          gitAndTools.git-extras
          mypy
          neovim
          neovim-remote
          nix-prefetch-scripts
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
        python27Packages.alot # python 2 only
        khal
        khard
        msmtp
        newsbeuter
        notmuch
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
  programs.rofi = {
    enable = true;
  };

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
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      #mostly for testin
      dfh="df --human-readable";
      duh="du --human-readable";
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
  programs.firefox = {
    enable = true;
    enableAdobeFlash = true;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}
