{ config, pkgs, lib,  ... }:
let
  terminalCommand = pkgs.kitty;

  # TODO copy it
  unicode-data = pkgs.fetchurl {
    url = "http://www.unicode.org/Public/UNIDATA/UnicodeData.txt";
    sha256 = "16b0jzvvzarnlxdvs2izd5ia0ipbd87md143dc6lv6xpdqcs75s9";
  };

  texliveEnv = pkgs.texlive.combine {
    # tabularx is not available
    inherit (pkgs.texlive) scheme-small cleveref latexmk bibtex algorithms cm-super
    csvsimple subfigure  glossaries biblatex logreq xstring biblatex-ieee subfiles mfirstuc;
   };

  devPkgs = all: with pkgs; let
    in
    [
    # TODO pass to vim makeWrapperArgs
    # nodePackages.bash-language-server
    # just in my branch :'(
    # luaPackages.lua-lsp
    nixpkgs-fmt
    editorconfig-core-c
    exa  # to list files
    gdb
    git-review # to contribute to wireshark

    gitAndTools.diff-so-fancy # todo install it via the git config instead
    gitAndTools.gitbatch   # to fetch form several repos at once
    gitAndTools.gh  # github client
    # gitAndTools.git-remote-hg
    gitAndTools.git-recent
    # gitAndTools.git-annex # fails on unstable
    gitAndTools.git-extras
    gitAndTools.git-crypt
    gitAndTools.lab
    patchutils  # for interdiff
    lazygit  # kinda like tig
    ncurses.dev # for infocmp
    neovim-remote # for latex etc
    # nix-prefetch-scripts # broken
    nix-index # to list package contents
    nixpkgs-review
    pcalc  # cool calc
    rpl    # to replace strings across files
    universal-ctags  # there are many different ctags, be careful !
  ]
  ++ lib.optionals all [
    hexyl  # hex editor
  ];

  imPkgs = all: with pkgs;
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
    khard
    libsecret  # to consult
    newsboat #
    customWeechat
    # leafnode dovecot22 dovecot_pigeonhole fetchmail procmail w3m
    # mairix mutt msmtp lbdb contacts spamassassin
  ] ++ lib.optionals all [
    slack
  ];


  desktopPkgs = all: with pkgs; [
    # apvlv # broken
    # alsa-utils # for alsamixer
    arandr  # to move screens/monitors around
    bandwhich  # to monitor per app bandwidth
    du-dust  # dust binary: rust replacement of du
    hunspellDicts.fr-any
    # buku  # broken on unstable and stable
    # dynamic-colors # to change the terminal colors ("dynamic-colors switch solarized-dark")
    # gcalc
    gnome3.networkmanagerapplet # should
    gnome3.defaultIconTheme # else nothing appears
    # i3-layout-manager  # to save/load layouts
    # mpv # broken on unstable
    kitty
    libnotify
    # unstable.evince # succeed where zathura/mupdf fail

    # conflicts with nautilus
    gnome3.file-roller # for GUI archive handling
    ffmpegthumbnailer # to preview videos in ranger
    # todo try sthg else
    # requires xdmcp https://github.com/freedesktop/libXdmcp
    gnome3.eog # eye of gnome = image viewer / creates a collision
    moc  # music player
    mupdf.bin # evince does better too
    # mdp # markdown CLI presenter
    # gnome3.gnome_control_center
    ncpamixer # pulseaudio TUI mixer
    noti # send notifications when a command finishes
    # papis # library manager
    pass
    pavucontrol
    procs  # Rust replacement for 'ps'
    qtpass
    sublime3
    scrot  # screenshot app for wayland
    # smplayer # GUI around mpv

    sd  # rust cli for search & replace
    sxiv # simple image viewer
    # vimiv # image viewer
    shared_mime_info # temporary fix for nautilus to find the correct files
    tagainijisho # japanse dict; like zkanji Qt based
    translate-shell
    # unstable.transmission_gtk  # bittorrent client
    xdotool # needed for vimtex + zathura
    xarchiver # to unpack/pack files
    xorg.xev
    xorg.xbacklight  # todo should be set from module
    xclip
    xcwd
    wally-cli  # to flash ergodox keyboards
    wireshark
    zathura
  ]
  ++ lib.optionals all [
    gnome3.gnome-calculator  # compare with qalqulate-gtk
  ]
  ;

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
    # unstable.libreoffice
    # unstable.wireshark

    # unstable.qutebrowser  # keyboard driven fantastic browser
    gnome3.nautilus # demande webkit/todo replace by nemo ?
    # shutter # screenshot utility
    # mcomix # manga reader
    # mendeley # requiert qtwebengine
    zeal       # doc for developers
    vifm
    # zotero     # doc software
    # astroid # always compiles webkit so needs 1 full day
  ];
in
{

  imports = [
    ./common.nix
    ./dev.nix
    # ./modules/home-tor.nix
    ./i3.nix
    ./firefox.nix
    ./neovim.nix
  ];

  # rename to fn, accept a parameter for optional
  home.packages =
    (desktopPkgs true) ++ (devPkgs true) ++ heavyPackages
    ++ (imPkgs true)
    ++ [
      # pkgs.up # live preview of pipes
      pkgs.peek # GIF recorder

      # unstable.cachix  # almot always broken
    ]
   ;


  # tray is enabled by default
  services.udiskie = {
    enable = true;
    notify = false;
    automount = false;
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
    terminal = "${pkgs.kitty}/bin/kitty";
    borderWidth = 1;
    theme = "solarized_alternate";
    # lines= ;
    location = "center";

    # rofi.font: SourceCodePro 9
    # font =
    # ,Layouts:${../../bin/i3-list-layouts}
    extraConfig=''
      !rofi.opacity: 90
      !rofi.width: 50
      rofi.columns: 1
      rofi.fuzzy: true
      rofi.show-icons: true
      ! cd window
      rofi.modi:       run,drun,window,ssh
      /* see to integrate teiler */
      rofi.sidebar-mode: true

      rofi.kb-mode-previous: Alt+Left
      rofi.kb-mode-next:	Alt+Right,Alt+Tab

    '';
  };


  services.mpd = {
    enable = false;
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

  services.parcellite.enable = false;

  # might trigger nm-applet crash ?
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
    # grabKeyboardAndMouse= false;
    # pinentryFlavor = "curses";
    pinentryFlavor = "qt";
    grabKeyboardAndMouse = true;  # should be set to false instead
    verbose = true;
    # see https://github.com/rycee/home-manager/issues/908
    # could try ncurses as well
    # extraConfig = ''
    #   pinentry-program ${pkgs.pinentry-gnome}/bin/pinentry-gnome3
    # '';
  };

  # needed for gpg-agent gnome pinentry
  # services.dbus.packages = [ pkgs.gcr ];

  xsession = {
    enable = true;

    profileExtra = ''
      # export ZDOTDIR=
    '';

    # initExtra = ''
    #   ${pkgs.feh}/bin/feh --bg-fill /home/teto/dotfiles/wallpapers/nebula.jpg
    # '';
  };

  # as long as there is no better way to configure i3
  home.file.".pypirc".source = ../../home/pypirc;

  # readline equivalent but in haskell for ghci
  # home.file.".haskeline".source = ../home/haskeline;

  #  TODO newsboat
  # programs.newsboat.urls =

  programs.termite = {
    enable = false;

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

# [Added Associations]
# video/x-matroska=vlc.desktop;mpv.desktop;
# video/mp4=vlc.desktop;mpv.desktop;userapp-mpv-DXOVBY.desktop;
# text/csv=sublime_text.desktop;
# video/x-msvideo=mpv.desktop;
# application/x-matroska=mpv.desktop;
# text/x-patch=sublime_text.desktop;
# text/x-chdr=sublime_text.desktop;
# text/plain=sublime_text.desktop;
# application/binary=sublime_text.desktop;
# application/zip=xarchiver.desktop;
# image/gif=qiv.desktop;
# text/x-rockspec=sublime_text.desktop;

# [Removed Associations]
# application/pdf=Mendeley.desktop


}
