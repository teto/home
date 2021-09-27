{ config, pkgs, lib,  ... }:
let
  terminalCommand = pkgs.kitty;

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


      # gdb-debug = prev.enableDebgging prev.gdb ;
    # gitAndTools.git-annex # fails on unstable
    # gitAndTools.git-remote-hg
    # nix-prefetch-scripts # broken
    gdb
    editorconfig-core-c
    exa  # to list files
    gitAndTools.diff-so-fancy # todo install it via the git config instead
    gitAndTools.gh  # github client
    gitAndTools.git-crypt
    gitAndTools.git-extras
    gitAndTools.git-recent
    gitAndTools.gitbatch   # to fetch form several repos at once
    gitAndTools.lab
    lazygit  # kinda like tig
    ncurses.dev # for infocmp
    neovim-remote # for latex etc
    nix-doc # to access nix doc
    nix-index # to list package contents
    nixpkgs-fmt
    nixpkgs-review
    nodePackages.bitwarden-cli  # 'bw' binary
    patchutils  # for interdiff
    pcalc  # cool calc
    rpl    # to replace strings across files
    universal-ctags  # there are many different ctags, be careful !
    # virtmanager  # broken
  ]
  ++ lib.optionals all [
    hexyl  # hex editor
  ];

  imPkgs = all: with pkgs;
    let
  in [
    # gnome3.california # fails
    khard
    # libsecret  # to consult
    newsboat #
    # leafnode dovecot22 dovecot_pigeonhole fetchmail procmail w3m
    # mairix mutt msmtp lbdb contacts spamassassin
  ] ++ lib.optionals all [
    element-desktop
    slack
  ];


  desktopPkgs = let
    # wrap moc to load config from XDG_CONFIG via -C
    moc-wrapped = pkgs.symlinkJoin {
      name = "moc-wrapped-${pkgs.moc.version}";
      paths = [ pkgs.moc ];
      buildInputs = [ pkgs.makeWrapper ];
      # passthru.unwrapped = mpv;
      postBuild = ''
        # wrapProgram can't operate on symlinks
        rm "$out/bin/mocp"
        makeWrapper "${pkgs.moc}/bin/mocp" "$out/bin/mocp" --add-flags "-C $XDG_CONFIG_HOME/moc/config"
        # rm "$out/bin/mocp"
      '';
    };

  in all: with pkgs; [
    # apvlv # broken
    # TODO
    # buku # broken
    # gcalc
    # gnome3.gnome_control_center
    # i3-layout-manager  # to save/load layouts
    # mdp # markdown CLI presenter
    # nyxt      # lisp browser
    # papis # library manager
    # requires xdmcp https://github.com/freedesktop/libXdmcp
    # smplayer # GUI around mpv
    # todo try sthg else
    # unstable.evince # succeed where zathura/mupdf fail
    # unstable.transmission_gtk  # bittorrent client
    # vimiv # image viewer
    arandr  # to move screens/monitors around
    bandwhich  # to monitor per app bandwidth
    du-dust  # dust binary: rust replacement of du
    font-manager
    gnome3.defaultIconTheme # else nothing appears
    gnome3.eog # eye of gnome = image viewer / creates a collision
    gnome3.file-roller # for GUI archive handling
    gnome3.networkmanagerapplet # should
    hunspellDicts.fr-any
    libnotify
    # luarocks
    magic-wormhole  # super tool to exchange secrets between computers
    moc-wrapped  # music player
    mupdf.bin # evince does better too
    ncpamixer # pulseaudio TUI mixer
    noti # send notifications when a command finishes
    pass
    pavucontrol
    procs  # Rust replacement for 'ps'
    qiv  # image viewer
    qtpass
    rbw   # Rust bitwarden unofficial client
    rofi-pass   # rofi-pass
    scrot  # screenshot app for wayland
    sd  # rust cli for search & replace
    shared_mime_info # temporary fix for nautilus to find the correct files
    sublime3
    sxiv # simple image viewer
    translate-shell
    wally-cli  # to flash ergodox keyboards
    wireshark
    xarchiver # to unpack/pack files
    xclip
    xcwd
    xdotool # needed for vimtex + zathura
    xorg.xbacklight  # todo should be set from module
    xorg.xev
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

    qutebrowser  # keyboard driven fantastic browser
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
    ./kitty.nix
    ./rofi.nix
    ./mpv.nix
    ./dev.nix
    # ./modules/home-tor.nix
    ./ssh-config.nix
    ./i3.nix

    ./fcitx.nix
    ./firefox.nix
    ./notifications.nix
    ./neovim.nix
    # ./neovim-minimal.nix
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

  services.mpd = {
    enable = false;
    # dataDir = xdg.dataDir
    # musicDirectory = 
    # extraConfig = 
  };

  services.flameshot.enable = true;

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
  services.parcellite.enable = true;

  programs.pywal.enable = true;

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
  programs.rbw = {
    enable = true;
    settings = {
        email = config.accounts.email.accounts.fastmail.address;
        lock_timeout = 300;
        pinentry = "gnome3";
    };
  };


}
