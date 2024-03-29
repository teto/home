{ config, flakeInputs, pkgs, lib, system, ... }:
let

  pass-custom = (pkgs.pass.override { waylandSupport = true; }).withExtensions (ext:
    with ext; [ pass-import ]);


  devPkgs = with pkgs; [
    # TODO pass to vim makeWrapperArgs
    # nodePackages.bash-language-server
    # just in my branch :'(
    # luaPackages.lua-lsp
    # gdb-debug = prev.enableDebgging prev.gdb ;
    # gitAndTools.git-annex # fails on unstable
    # gitAndTools.git-remote-hg
    # nix-prefetch-scripts # broken

    backblaze-b2

    gdb
    # editorconfig-core-c
    automake
    gnum4 # hum
    # for fuser, useful when can't umount a directory
    # https://unix.stackexchange.com/questions/107885/busy-device-on-umount
    psmisc
    util-linux # for lsns (namespace listing)
    rbw

	# haxe # to test neovim developement
    eza # to list files
    gitAndTools.diff-so-fancy # todo install it via the git config instead
    gitAndTools.gh # github client
    gitAndTools.git-absorb
    gitAndTools.git-crypt
    gitAndTools.git-extras
    gitAndTools.git-recent # 
    gitAndTools.gitbatch # to fetch form several repos at once
    gitAndTools.lab


	haskellPackages.fast-tags
    hurl # http tester

    llm-ls # needed by the neovim plugin


    presenterm # for presentations from terminal/markdown (in rust, supports images, pretty cool)
    
    perf-tools

	inotify-tools # for inotify-wait notably
    just # to read justfiles, *replace* Makefile
    ncurses.dev # for infocmp
    # neovide
    # neovim-remote # broken for latex etc
    nix-doc # can generate tags for nix
    nix-output-monitor
    nix-update # nix-update <ATTR> to update a software
    nix-index # to list package contents
    nix-top # to list current builds
    nixpkgs-fmt
    nixpkgs-review
    # nodePackages."@bitwarden/cli" # 'bw' binary # broken
    patchutils # for interdiff
    pcalc # cool calc
    rpl # to replace strings across files
    universal-ctags # there are many different ctags, be careful !
    tio # serial console reader
	viu # a console image viewer
    hexyl # hex editor
    whois
    envsubst
    w3m # for preview in ranger w3mimgdisplay
    zeal # doc for developers
  ];

  imPkgs = with pkgs; [
    # gnome.california # fails
    khard
    # libsecret  # to consult
    newsboat #
    mujmap # to sync notmuch tags across jmap 
    # memento # broken capable to display 2 subtitles at same time
    vlc
    # leafnode dovecot22 dovecot_pigeonhole fetchmail procmail w3m
    # mairix mutt msmtp lbdb contacts spamassassin
    element-desktop
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
    with pkgs; [
      # TODO
      # apvlv # broken
      # buku # broken
      # gcalc
      # gnome.gnome_control_center
      # gthumb # image manager, great to tag pictures
      # magic-wormhole  # super tool to exchange secrets between computers
      # mdp # markdown CLI presenter
      # nomacs # image viewer
      # nyxt      # lisp browser
      # pulseaudioFull # for pactl
      # replace with rust-wormhole
      # requires xdmcp https://github.com/freedesktop/libXdmcp
      # scrot # screenshot app for xorg
      # smplayer # GUI around mpv
      # sxiv # simple image viewer
      # todo try sthg else
      # unstable.transmission_gtk  # bittorrent client
      # vimiv # image viewer
      # ytfzf # broken browse youtube
      # zathura # broken
	  simple-scan
	  usbutils
	  vifm
      bandwhich # to monitor per app bandwidth
      desktop-file-utils # to get desktop
      dogdns # dns solver "dog"
      du-dust # dust binary: rust replacement of du
      duf # better df (rust)
      evince # succeed where zathura/mupdf fail
      flakeInputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins
      font-manager
      gnome.adwaita-icon-theme # else nothing appears
      gnome.eog # eye of gnome = image viewer / creates a collision
      gnome.file-roller # for GUI archive handling
      hunspellDicts.fr-any
      imv # image viewer
      jaq # jq in rust
      jq # to run json queries
      lazygit # kinda like tig
      libnotify
      moc-wrapped # music player
      mupdf.bin # evince does better too

      ## Alternatives to consider:
      # - gdu
      # - pdu
      # - dua
      ncdu # to see disk usage
      
      ncpamixer # pulseaudio TUI mixer
      noti # send notifications when a command finishes
      ouch # to (de)compress files
      papis # library manager
      pass-custom # pass with extensions
      pavucontrol
      pkgs.networkmanagerapplet # should
      procs # Rust replacement for 'ps'
      qiv # image viewer
      qtpass
      ranger # or joshuto ? see hm configuration
      restic  # to backup photos to backblaze
      rbw # Rust bitwarden unofficial client
      ripgrep
      rofi-pass # rofi-pass it's enabled in the HM module ?
      rsync
      sd # rust cli for search & replace
      shared-mime-info # temporary fix for nautilus to find the correct files
      simple-scan
      sioyek # pdf reader
      sops # password 'manager'
      sublime3
      translate-shell # call with `trans`
      unzip
      wally-cli # to flash ergodox keyboards
      wine
      wireshark
      wttrbar # for meteo
      xarchiver # to unpack/pack files
      xdg-utils
    ]
    #   gnome.gnome-calculator # compare with qalqulate-gtk
  ;

  # the kind of packages u don't want to compile
  # TODO les prendres depuis un channel avec des binaires ?
  heavyPackages = with flakeInputs.nixos-stable.legacyPackages.${pkgs.system}; [
    # anki          # spaced repetition system
    # hopefully we can remove this from the environment
    # it's just that I can't setup latex correctly
    libreoffice

	# take the version from stable ?
    # qutebrowser # broken keyboard driven fantastic browser
    gnome.nautilus # demande webkit/todo replace by nemo ?
    # mcomix # manga reader
  ];
in
{

  imports = [
    ./common.nix
    ./kitty.nix
    ./mpv.nix
    ./mpd.nix
    ./dev.nix
    ./rofi.nix
    ./wal.nix
    ./sway.nix

    ./nushell.nix
    ./fcitx.nix
    ./firefox.nix
    ./neovim.nix

  ];

  # programs.autojump = {
  #   enable = false;
  #   enableZshIntegration = true;
  #   enableBashIntegration = true;
  # };

  fonts.fontconfig.enable = true;

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    options = [ "--cmd j" ];
  };


  # rename to fn, accept a parameter for optional
  home.packages =
   desktopPkgs 
   ++ devPkgs  ++ heavyPackages
    ++ imPkgs
    ++ (with pkgs; [
      # pkgs.up # live preview of pipes
      # pkgs.peek # GIF recorder  BROKEN
	  pkgs.alsa-utils #  for alsamixer
      pinentry-bemenu
      pinentry-rofi
    ])
  ;

  # TODO remove ? dangerous
  home.sessionPath = [
    "$XDG_DATA_HOME/../bin"
  ];

  # tray is enabled by default
  services.udiskie = {
    enable = true; # broken
    notify = false;
    automount = false;
  };

  programs.browserpass = {
    enable = true;
	browsers = [ 
	 "firefox"
	 "chromium"
	];
  };

  services.gnome-keyring = {
    enable = true;
  };

  services.network-manager-applet.enable = true;

  services.flameshot.enable = true;

  # programs.gpg-agent = {
  # # --max-cache-ttl
  # };

  # might trigger nm-applet crash ?
  # TODO disable it ?
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



  # readline equivalent but in haskell for ghci
  # home.file.".haskeline".source = ../home/haskeline;


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
  # programs.navi = {
  #   enable = true;
  #   # disabled bcecause it interferes with our fzf widgets mappings
  #   enableZshIntegration = false;
  # };

  # broot is a terminal file navigator
  programs.broot = {
    enable = true;
    enableZshIntegration = true;

    # alt+enter is taken by i3 see https://github.com/Canop/broot/issues/86
    # settings.verbs = [{ invocation = "p"; key = "ctrl-o"; execution = ":open_leave"; }];
  };

  home.sessionVariables = {
    # JUPYTER_CONFIG_DIR=
    IPYTHONDIR = "$XDG_CONFIG_HOME/ipython";
    JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
    # testing if we can avoid having to symlink XDG_CONFIG_HOME
    # should be setup by neomutt module
    # MUTT="$XDG_CONFIG_HOME/mutt";
    VIM_SOURCE_DIR = "$HOME/vim";
  };

  # export XDG_ settings
  # systemd.user.sessionVariables = {};

  # https://github.com/NixOS/nixpkgs/issues/196651
  manual.manpages.enable = true;

  # TODO fix that
  # systemd.user.sessionVariables = {
  # NOTMUCH_CONFIG=home.sessionVariables.NOTMUCH_CONFIG;
  # };
}
