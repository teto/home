{ config, flakeInputs, pkgs, lib, system, ... }:
let
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
    automake
    gnum4 # hum
    # for fuser, useful when can't umount a directory
    # https://unix.stackexchange.com/questions/107885/busy-device-on-umount
    psmisc
    util-linux # for lsns (namespace listing)
    rbw
	# haxe # to test neovim developement
    exa # to list files
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
    perf-tools

	inotify-tools # for inotify-wait notably
    just # to read justfiles, *replace* Makefile
    ncurses.dev # for infocmp
    neovide
    # neovim-remote # broken for latex etc
    nix-output-monitor
    nix-update # nix-update <ATTR> to update a software
    nix-index # to list package contents
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
  ];

  imPkgs = all: with pkgs; [
    # gnome.california # fails
    khard
    # libsecret  # to consult
    newsboat #
    mujmap # to sync notmuch tags across jmap 
    # memento # broken capable to display 2 subtitles at same time
    vlc
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
      flakeInputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins
      jq # to run json queries
      lazygit # kinda like tig
      buku # broken
      # gcalc
      # gnome.gnome_control_center
      # mdp # markdown CLI presenter
      # nyxt      # lisp browser
      papis # library manager
      # requires xdmcp https://github.com/freedesktop/libXdmcp
      # smplayer # GUI around mpv
      # todo try sthg else
      evince # succeed where zathura/mupdf fail
      # unstable.transmission_gtk  # bittorrent client
      # vimiv # image viewer
	  usbutils
      imv # image viewer
	  vifm

      bandwhich # to monitor per app bandwidth
      du-dust # dust binary: rust replacement of du
      dogdns # dns solver "dog"
      ncdu # to see disk usage
      nomacs # image viewer
      desktop-file-utils # to get desktop
      font-manager
      # gthumb # image manager, great to tag pictures
      gnome.adwaita-icon-theme # else nothing appears
      gnome.eog # eye of gnome = image viewer / creates a collision
      gnome.file-roller # for GUI archive handling
      pkgs.networkmanagerapplet # should
      wine
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
      # scrot # screenshot app for xorg
      sops # password 'manager'
      sd # rust cli for search & replace
      shared-mime-info # temporary fix for nautilus to find the correct files
      sublime3
      # sxiv # simple image viewer
	  simple-scan
      translate-shell # call wiuth `trans`
      wally-cli # to flash ergodox keyboards
      wireshark
      xarchiver # to unpack/pack files
      # zathura # broken
      ytfzf # browse youtube
      ranger # or joshuto ? see hm configuration
      rsync
      ripgrep
      unzip
    ]
    #   gnome.gnome-calculator # compare with qalqulate-gtk
  ;

  # the kind of packages u don't want to compile
  # TODO les prendres depuis un channel avec des binaires ?
  heavyPackages = with flakeInputs.nixos-stable.legacyPackages.${pkgs.system}; [
    # anki          # spaced repetition system
    # hopefully we can remove this from the environment
    # it's just that I can't setup latex correctly
    # unstable.libreoffice

	# take the version from stable ?
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

  programs.autojump = {
    enable = false;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
  # programs.z-lua = {
  #   enable = false;
  #   enableZshIntegration = true;
  # };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    options = [ "--cmd j" ];
  };


  # rename to fn, accept a parameter for optional
  home.packages =
    (desktopPkgs true) ++ (devPkgs true) ++ heavyPackages
    ++ (imPkgs true)
    ++ (with pkgs; [
      # pkgs.up # live preview of pipes
      # pkgs.peek # GIF recorder  BROKEN
	  pkgs.alsa-utils #  for alsamixer
      pinentry-bemenu
      pinentry-rofi
    ])
  ;

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
	 # "chromium"
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


  programs.rofi.theme = {
    "@import" = "${config.xdg.cacheHome}/wal/colors-rofi-dark.rasi";
    "@theme" = "purple";
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


  programs.joshuto = {

   enable = true;
   # settings = {
   #   preview = {
   #     preview_shown_hook_script = "~/.config/joshuto/on_preview_shown";
   #     preview_removed_hook_script = "~/.config/joshuto/on_preview_removed";
   #   };
   # };
   # [preview]
# ...
# preview_shown_hook_script = "~/.config/joshuto/on_preview_shown"
# preview_removed_hook_script = "~/.config/joshuto/on_preview_removed"
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



  # https://github.com/NixOS/nixpkgs/issues/196651
  manual.manpages.enable = true;

  services.nextcloud-client.enable = true;

  # TODO fix that
  # systemd.user.sessionVariables = {
  # NOTMUCH_CONFIG=home.sessionVariables.NOTMUCH_CONFIG;
  # };
}
