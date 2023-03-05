{ config, pkgs, lib, ... }:
let
  # terminalCommand = pkgs.kitty;

  pass-custom = (pkgs.pass.override { waylandSupport = true; }).withExtensions (ext:
    with ext; [ pass-import ]);

  devPkgs = all: with pkgs; [
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
    rbw
	haxe
    exa # to list files
    gitAndTools.diff-so-fancy # todo install it via the git config instead
    gitAndTools.gh # github client
    gitAndTools.git-absorb
    gitAndTools.git-crypt
    gitAndTools.git-extras
    gitAndTools.git-recent
    gitAndTools.gitbatch # to fetch form several repos at once
    gitAndTools.lab
	inotify-tools # for inotify-wait notably
    jq # to run json queries
    lazygit # kinda like tig
    ncurses.dev # for infocmp
    neovide
    # neovim-remote # broken for latex etc
    # nix-doc # to access nix doc (broken)
    manix
    nix-output-monitor
    nix-update # nix-update <ATTR> to update a software
    nix-index # to list package contents
    nixpkgs-fmt
    nixpkgs-review
    nodePackages.bitwarden-cli # 'bw' binary
    patchutils # for interdiff
    pcalc # cool calc
    rpl # to replace strings across files
    universal-ctags # there are many different ctags, be careful !
    tio # serial console reader
    wine
  ]
  ++ lib.optionals all [
    hexyl # hex editor
  ];

  imPkgs = all: with pkgs; [
    # gnome.california # fails
    khard
    # libsecret  # to consult
    newsboat #
    mujmap # to sync notmuch tags across jmap 
    # leafnode dovecot22 dovecot_pigeonhole fetchmail procmail w3m
    # mairix mutt msmtp lbdb contacts spamassassin
  ] ++ lib.optionals all [
    element-desktop
    slack
  ];


  desktopPkgs =
    let
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

    in
    all: with pkgs; [
      # apvlv # broken
      # TODO
      # buku # broken
      # gcalc
      # gnome.gnome_control_center
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
	  usbutils
	  vifm

      arandr # to move screens/monitors around
      bandwhich # to monitor per app bandwidth
      du-dust # dust binary: rust replacement of du
      ncdu # to see disk usage
      nomacs # image viewer
      desktop-file-utils # to get desktop
      font-manager
      # gthumb # image manager, great to tag pictures
      gnome.adwaita-icon-theme # else nothing appears
      gnome.eog # eye of gnome = image viewer / creates a collision
      gnome.file-roller # for GUI archive handling
      pkgs.networkmanagerapplet # should
      hunspellDicts.fr-any
      libnotify
      # luarocks
      # magic-wormhole  # super tool to exchange secrets between computers
      moc-wrapped # music player
      mupdf.bin # evince does better too
      ncpamixer # pulseaudio TUI mixer
      noti # send notifications when a command finishes
      pass-custom # pass with extensions
      # pulseaudioFull # for pactl
      pavucontrol
      procs # Rust replacement for 'ps'
      qiv # image viewer
      qtpass
      rbw # Rust bitwarden unofficial client
      rofi-pass # rofi-pass it's enabled in the HM module ?
      scrot # screenshot app for wayland
      sd # rust cli for search & replace
      shared-mime-info # temporary fix for nautilus to find the correct files
      sublime3
      # sxiv # simple image viewer
      translate-shell
      wally-cli # to flash ergodox keyboards
      wireshark
      xarchiver # to unpack/pack files
      # xbacklight # for usage with i3pystatus backight module
      xclip
      xcwd
      xdotool # needed for vimtex + zathura
      xorg.xbacklight # todo should be set from module
      xorg.xev
      # zathura # broken
    ]
    ++ lib.optionals all [
      gnome.gnome-calculator # compare with qalqulate-gtk
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

    # qutebrowser # broken keyboard driven fantastic browser
    gnome.nautilus # demande webkit/todo replace by nemo ?
    # shutter # screenshot utility
    # mcomix # manga reader
    # mendeley # requiert qtwebengine
    zeal # doc for developers
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
    ./wal.nix

    ./nushell.nix
    ./fcitx.nix
    ./firefox.nix
    ./notifications.nix
    ./neovim.nix
  ];

  # rename to fn, accept a parameter for optional
  home.packages =
    (desktopPkgs true) ++ (devPkgs true) ++ heavyPackages
    ++ (imPkgs true)
    ++ [
      # pkgs.up # live preview of pipes
      pkgs.peek # GIF recorder

      pkgs.cachix  # almot always broken
    ]
  ;

  home.sessionPath = [
    "$XDG_DATA_HOME/../bin"
    "/home/teto/.cache/cabal/bin"
  ];

  # tray is enabled by default
  services.udiskie = {
    enable = true;
    notify = false;
    automount = false;
  };

  programs.browserpass = {
    enable = true;
    browsers = [ "firefox" "chromium" ];
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

  # programs.gpg-agent = {
  # # --max-cache-ttl
  # };

  # might trigger nm-applet crash ?
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 7200;
    # maxCacheTtl
    enableSshSupport = true;
    # grabKeyboardAndMouse= false;
    # pinentryFlavor = "curses";
    pinentryFlavor = "qt";
    grabKeyboardAndMouse = true; # should be set to false instead
    # default-cache-ttl 60
    verbose = true;
    # --max-cache-ttl
    maxCacheTtl = 86400; # in seconds (86400 = 1 day)
    # see https://github.com/rycee/home-manager/issues/908
    # could try ncurses as well
    # extraConfig = ''
    #   pinentry-program ${pkgs.pinentry-gnome}/bin/pinentry-gnome
    # '';
  };

  # needed for gpg-agent gnome pinentry
  # services.dbus.packages = [ pkgs.gcr ];
  services.parcellite.enable = true;


  programs.rofi.theme = {
    "@import" = "${config.xdg.cacheHome}/wal/colors-rofi-dark.rasi";
    "@theme" = "purple";
  };

  xsession = {
    enable = false;
    # will enable SNI for nm-applet => icon will popup on wayland systray
    preferStatusNotifierItems = true;
    scriptPath = ".hm-xsession";

    profileExtra = ''
    '';
  };


  # as long as there is no better way to configure i3
  # home.file.".pypirc".source = ../../home/pypirc;

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
    enable = false;
    settings = {
      email = config.accounts.email.accounts.fastmail.address;
      lock_timeout = 300;
      pinentry = "gnome";
      # see https://github.com/nix-community/home-manager/issues/2476
      device_id = "111252f7-88b7-47f2-abb9-03dc4b2469ed";
    };
  };

  # cheatsheets from terminal
  programs.navi = {
    enable = true;
    # disabled bcecause it interferes with our fzf widgets mappings
    enableZshIntegration = false;
  };

  # broot is a terminal file navigator
  programs.broot = {
    enable = true;
    enableZshIntegration = true;

    # alt+enter is taken by i3 see https://github.com/Canop/broot/issues/86
    settings.verbs = [{ invocation = "p"; key = "ctrl-o"; execution = ":open_leave"; }];
  };

  # for pinentry-gnome to work longer

  # Works only on x11
  # systemd.user.services.deadd = {
  #   Unit = {
  #     Description = "Linux notification manager";
  #     After = [ "graphical-session-pre.target" ];
  #     PartOf = [ "graphical-session.target" ];
  #   };
  #   Service = {
  #     Type = "dbus";
  #     BusName = "org.freedesktop.Notifications";
  #     ExecStart = "${pkgs.deadd-notification-center}/bin/linux_notification_server";
  #     # Environment = optionalString (cfg.waylandDisplay != "")
  #     #   "WAYLAND_DISPLAY=${cfg.waylandDisplay}";
  #   };
  # };


  # https://github.com/NixOS/nixpkgs/issues/196651
  manual.manpages.enable = true;

  wayland.windowManager.sway = {
    extraOptions = [ "--unsupported-gpu" ];
  };
  # TODO fix that
  # systemd.user.sessionVariables = {
  # NOTMUCH_CONFIG=home.sessionVariables.NOTMUCH_CONFIG;
  # };
}
