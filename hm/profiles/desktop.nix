{ config, flakeInputs, pkgs, lib, system, ... }:
let


  fontsPkgs = with pkgs; [
      # fonts
      ubuntu_font_family
      inconsolata # monospace
      noto-fonts-cjk # asiatic
      nerdfonts # otherwise no characters
      # (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })

      # corefonts # microsoft fonts  UNFREE
      font-awesome_5
      source-code-pro
      dejavu_fonts
      # Adobe Source Han Sans
      source-han-sans #sourceHanSansPackages.japanese
      fira-code-symbols # for ligatures
      iosevka

    ];

in
{

  imports = [
    ./xdg-portal.nix
    ./common.nix
    ./kitty.nix
    ./mpv.nix
    ./mpd.nix
    ./dev.nix
    ./rofi.nix
    ./wal.nix
    ./sway.nix
    ./zsh.nix

    ./fcitx.nix
    ./firefox.nix
    ./neovim.nix

  ];

  # allows to find fonts enabled through home.packages
  fonts.fontconfig.enable = true;

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    options = [ "--cmd k" ];
  };

  package-sets = {
    developer = true;
    enableDesktopPackages = true;
  };

  # rename to fn, accept a parameter for optional
  home.packages =
      fontsPkgs
   ++ (with pkgs; [
      # pkgs.up # live preview of pipes
      # pkgs.peek # GIF recorder  BROKEN
	  pkgs.alsa-utils #  for alsamixer
      # pinentry-bemenu
      pinentry-rofi
      timg
      # pass-custom


    ])
  ;

  # TODO remove ? dangerous
  home.sessionPath = [
    "$XDG_DATA_HOME/../bin"
  ];

  # tray is enabled by default
  services.udiskie = {
    enable = true;
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
    grabKeyboardAndMouse = false; # should be set to false instead
    # default-cache-ttl 60
    verbose = true;
    # --max-cache-ttl
    maxCacheTtl = 86400; # in seconds (86400 = 1 day)

    pinentryPackage = pkgs.pinentry-gnome3;
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
    enable = true;
    settings = {
      email = config.accounts.email.accounts.fastmail.address;
      lock_timeout = 300;
      pinentry = pkgs.pinentry-gnome3;
      # see https://github.com/nix-community/home-manager/issues/2476
      device_id = "111252f7-88b7-47f2-abb9-03dc4b2469ed";
    };
  };

  # broot is a terminal file navigator
  programs.broot = {
    enable = true;
    enableZshIntegration = true;

    # alt+enter is taken by i3 see https://github.com/Canop/broot/issues/86
    # settings.verbs = [{ invocation = "p"; key = "ctrl-o"; execution = ":open_leave"; }];
  };

  home.sessionVariables = {
    # JUPYTER_CONFIG_DIR=
    # testing if we can avoid having to symlink XDG_CONFIG_HOME
    # should be setup by neomutt module
    # MUTT="$XDG_CONFIG_HOME/mutt";
    # VIM_SOURCE_DIR = "$HOME/vim";
  };

  # export XDG_ settings
  # systemd.user.sessionVariables = {};

  # https://github.com/NixOS/nixpkgs/issues/196651
  manual.manpages.enable = true;

}
