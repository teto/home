{ config, pkgs, lib,  ... }:
let
  stable = import <nixos> {}; # https://nixos.org/channels/nixos
  unstable = import <nixos-unstable> {}; # https://nixos.org/channels/nixos-unstable

  terminalCommand = pkgs.termite;

  texliveEnv = pkgs.texlive.combine {
    # tabularx is not available
    inherit (pkgs.texlive) scheme-small cleveref latexmk bibtex algorithms cm-super
    csvsimple subfigure  glossaries biblatex logreq xstring biblatex-ieee subfiles mfirstuc;
   };

  devPkgs = with pkgs; let
      # float to use coc.nvim
      # TODO pass extraMakeWrapperArgs
      neovim-xp = pkgs.wrapNeovim pkgs.neovim-unwrapped-treesitter {
        # TODO pass lua-lsp
        # extraMakeWrapperArgs = " --prefix PATH ${pkgs.}"
        structuredConfigure = pkgs.neovimDefaultConfig;
      };
    in
    [
    editorconfig-core-c
    exa  # to list files
    gdb
    git-review # to contribute to wireshark

    gitAndTools.diff-so-fancy # todo install it via the git config instead
    # https://github.com/felipec/git-remote-hg
    # gitAndTools.git-remote-hg
    gitAndTools.git-recent
    # gitAndTools.git-annex # fails on unstable
    gitAndTools.git-extras
    gitAndTools.git-crypt
    # ccache # breaks some builds ? has to be configured via program, use ccacheStdEnv instead ?
    ncurses.dev # for infocmp
    neovim-xp   # hum remove ?
    neovim-remote # for latex etc
    nix-prefetch-scripts
    nix-index # to list package contents
    pcalc  # cool calc
    rpl # to replace strings across files
    universal-ctags  # there are many different ctags, be careful !
  ];

  imPkgs = with pkgs;
    let
      customWeechat = weechat.override {
        configure = { availablePlugins, ... }: {
          scripts = with pkgs.weechatScripts; [
            # weechat-xmpp weechat-matrix-bridge
            wee-slack
          ];
          init = ''
            /set plugins.var.python.jabber.key "val"
          '';
        };
      };
  in [
    # gnome3.california # fails
    # khal # => vdirsyncer !
    khard
    libsecret
    newsboat
    slack
    # vdirsyncer
    customWeechat
    # leafnode dovecot22 dovecot_pigeonhole fetchmail procmail w3m
    # mairix mutt msmtp lbdb contacts spamassassin
  ];

  desktopPkgs = with pkgs; [
    # apvlv # broken
    # alsa-utils # for alsamixer
    arandr  # to move screens/monitors around
    # buku
    dynamic-colors # to change the terminal colors ("dynamic-colors switch solarized-dark")
    # gcalc
    # unstable.dropbox
    gnome3.networkmanagerapplet # should
    gnome3.defaultIconTheme # else nothing appears
    mpv
    kitty
    libnotify
    # feh
    unstable.evince # succeed where zathura/mupdf fail
    # conflicts with nautilus
    # unstable.gnome3.file-roller # for GUI archive handling
    ffmpegthumbnailer # to preview videos in ranger
    # todo try sthg else
    # requires xdmcp https://github.com/freedesktop/libXdmcp
    # haskellPackages.greenclip # todo get from haskell
    unstable.gnome3.eog # eye of gnome = image viewer / creates a collision
    moc  # music player
    mupdf.bin # evince does better too
    # mdp # markdown CLI presenter
    # gnome3.gnome_control_center
    ncpamixer # pulseaudio TUI mixer
    noti # send notifications when a command finishes
    # papis # library manager
    unstable.gnome3.gnome-calculator
    pass
    qtpass
    sublime3
    scrot # screenshot app
    # smplayer # GUI around mpv
    sxiv # simple image viewer
    # system_config_printer # fails
    # vimiv # image viewer
    shared_mime_info # temporary fix for nautilus to find the correct files
    tagainijisho # japanse dict; like zkanji Qt based
    translate-shell
    unstable.transmission_gtk
    xdotool # needed for vimtex + zathura
    xarchiver # to unpack/pack files
    xorg.xev
    xorg.xbacklight
    xclip
    xcwd
    zathura
  ];

  home.sessionVariables = {
    # JUPYTER_CONFIG_DIR=

    # this variable is used by i3-sensible-terminal to determine the basic terminal
    TERMINAL = "kitty";
  };

  # the kind of packages u don't want to compile
  # TODO les prendres depuis un channel avec des binaires ?
  heavyPackages = with pkgs;[
    # anki          # spaced repetition system
    # hopefully we can remove this from the environment
    # it's just that I can't setup latex correctly
    unstable.libreoffice

    unstable.qutebrowser  # keyboard driven fantastic browser
    gnome3.nautilus # demande webkit/todo replace by nemo ?
    shutter # screenshot utility
    # mcomix # manga reader
    # mendeley # requiert qtwebengine
    pinta    # photo editing
    # unstable.qtcreator  # for wireshark
    zeal       # doc for developers
    vifm
    # zotero     # doc software
    # wavemon
    # astroid # always compiles webkit so needs 1 full day
  ];
in
{

  imports = [
    ./home-common.nix
    ./modules/home-tor.nix
    ./modules/i3.nix
  ];

  home.packages = desktopPkgs ++ devPkgs ++ heavyPackages
  ++ imPkgs ++ [
    # pkgs.up # live preview of pipes
    pkgs.peek # GIF recorder

    # pkgs.cachix  # almot always broken
    ]
   ;


  # tray is enabled by default
  services.udiskie = {
    enable = true;
    notify = false;
    automount = false;
  };

  # TODO prefix with stable
  programs.firefox = {
    enable = true;
    # package = unstable.firefox;
    # enableAdobeFlash = false;

    # Not accepted. we should find another way to enable it
    # pass package for instance
    # enableBukubrow = true;
  };

  programs.browserpass = {
    enable = true;
    browsers = ["firefox" "chromium" ];
  };

  services.gnome-keyring = {
    enable = true;
  };

  services.network-manager-applet.enable = true;

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.termite}/bin/termite";
    borderWidth = 1;
    theme = "solarized_alternate";
    # lines= ;
    location = "center";

    # rofi.font: SourceCodePro 9
    # font =
    extraConfig=''
      !rofi.opacity: 90
      !rofi.width: 50
      rofi.columns: 1
      rofi.fuzzy: true
      rofi.show-icons: true
      ! cd window
      rofi.modi:       run,drun,window,ssh,Layouts:${../bin/i3-list-layouts}
      /* see to integrate teiler */
      rofi.sidebar-mode: true

      rofi.kb-mode-previous: Alt+Left
      rofi.kb-mode-next:	Alt+Right,Alt+Tab

    '';
  };

  services.dunst = {
    enable=true;
    settings = {
      global={
        markup="full";
        sticky_history = true;
    # # Maximum amount of notifications kept in history
    # history_length = 20

    # # Display indicators for URLs (U) and actions (A).
        show_indicators = true;
        # TODO move it to module
        # browser = "";
        # dmenu = /usr/local/bin/rofi -dmenu -p dunst:
        alignment = "right";
        geometry = "500x30-30+20";

      };

      shortcuts = {

    # Redisplay last message(s).
    # On the US keyboard layout "grave" is normally above TAB and left
    # of "1". Make sure this key actually exists on your keyboard layout,
    # e.g. check output of 'xmodmap -pke'
    history = "ctrl+grave";
      };


# [shortcuts]

#     # Shortcuts are specified as [modifier+][modifier+]...key
#     # Available modifiers are "ctrl", "mod1" (the alt-key), "mod2",
#     # "mod3" and "mod4" (windows-key).
#     # Xev might be helpful to find names for keys.

#     # Close notification.
#     close = ctrl+space

#     # Close all notifications.
#     close_all = ctrl+shift+space

#     # Redisplay last message(s).
#     # On the US keyboard layout "grave" is normally above TAB and left
#     # of "1". Make sure this key actually exists on your keyboard layout,
#     # e.g. check output of 'xmodmap -pke'
#     history = ctrl+grave
    };
  };


  services.mpd = {
    enable = true;
    # dataDir = xdg.dataDir
    # musicDirectory = 
    # extraConfig = 
  };

  services.random-background = {
    enable = false;
    # imageDirectory =
    # interval =
  };

  # services.screen-locker.enable = true;

  # while waiting to fix greenclip related problems
  services.parcellite.enable = true;

  # might trigger nm-applet crash ?
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
    # grabKeyboardAndMouse= false;
    verbose = true;
  };

  # i3 now available !
  xsession = {
    enable = true;
    # export ZDOTDIR
    profileExtra = ''
      # export ZDOTDIR=
    '';

    # initExtra = ''
    #   ${pkgs.feh}/bin/feh --bg-fill /home/teto/dotfiles/wallpapers/nebula.jpg
    # '';
  };
  # xsession.windowManager.command = "…";
    # ${pkgs.networkmanagerapplet}/bin/nm-applet &

  # as long as there is no better way to configure i3
  # xsession.windowManager.command = "${pkgs.i3}/bin/i3";

  home.file.".pypirc".source = ../home/pypirc;

  # readline equivalent but in haskell for ghci
  # home.file.".haskeline".source = ../home/haskeline;

  #  TODO newsboat
  # programs.newsboat.urls =

  programs.termite = {
    enable = true;
    clickableUrl = false;
    cursorBlink = "system";
    cursorShape = "block";
    font = "Inconsolata 11";
    scrollOnKeystroke = true;
    scrollOnOutput = false;
    scrollbar = "right";
    searchWrap = false;
    scrollbackLines = 10000;
    fullscreen = false;
    optionsExtra = ''
    '';

    # read a different file depending on computer
    # colorsExtra = '' '';
  };


}
