# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true; # allows to run $ efi...

  # just to generate the entry used by ubuntu's grub
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # install to none, we just need the generated config
  # for ubuntu grub to discover
  boot.loader.grub.device = "/dev/sda";

  # see https://github.com/NixOS/nixpkgs/issues/15293
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [
    "af_key" # for ipsec/vpn support
  ];
  boot.kernel.sysctl = {
      # "net.ipv4.tcp_keepalive_time" = 60;
      # "net.core.rmem_max" = 4194304;
      # "net.core.wmem_max" = 1048576;
    };
  # boot.kernelPackages = pkgs.linuxPackages_mptcp;


  networking.hostName = "jedha"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n = {
     consoleFont = "Lat2-Terminus16";
     consoleKeyMap = "fr";
     defaultLocale = "fr_FR.UTF-8";
     inputMethod = {
       enabled = "fcitx";
       fcitx.engines = with pkgs.fcitx-engines; [
         mozc
       # hangul m17n
     ];
     };
   };

   # inspired by https://gist.github.com/539h/8144b5cabf97b5b206da
   fonts = {
      enableFontDir = true; # ?
      fonts = with pkgs; [
        ubuntu_font_family
        inconsolata
      ];
      # fontconfig= {
      #   enable=true;
      # }
   };


  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";
  time.timeZone = "Asia/Tokyo";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
     automake
     autoconf
     autojump
     cmake
     curl
     dex
	 dunst
	 fzf
     # lgogdownloader
     libtool
     # libreoffice # too long to compile
     libnotify # use via {pkgs.libnotify}/bin/notify-send
	 gawk
     git
	 # git-extras # does not find it (yet)
     gnome3.gnome_keyring
     gnome3.dconf # seems super important for dbus (https://github.com/NixOS/nixpkgs/issues/2448)
     gnum4 # hum
     gnupg
     ipsecTools # does it provide ipsec ?
     libertine # font
     google-fonts
	 mpv
	 ncmpcpp
     networkmanager
     # networkmanager_l2tp
     networkmanagerapplet
     # neovim
     pkgconfig
     # pypi2nix # to convert
     pass
	 qtpass
     ranger
     rofi
     ripgrep
     stow
     sudo
     termite
	 tmux
	 unzip
     vim
     vifm
	 # vlc
     xorg.xmodmap
     # xauth # for 'startx'
     wget
	 xclip
     xdg-user-dirs
     # xdg-utils
     zsh
   ] ++ [
  # TODO put some of the packages into an "extraPackages" set
  # or pin it to a binary version
    # astroid # might require a rebuild of webkit => too big
    # gnomecontrolcenter
    # cups-pk-helper # to add printer through gnome control center
   # ncdu
     # qutebrowser
     # python36Packages.jupyter_console
   ];


  environment.variables.EDITOR="nvim";


  # List services that you want to enable:
  services = {
    gnome3 = {
      gnome-keyring.enable = true;
      seahorse.enable = true;
      at-spi2-core.enable = true; # for keyring it seems
    };

    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint ];
    };

    openssh.enable = false;
    locate.enable = true;
  };


  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = true;
    displayManager = {
      auto = {
        enable = false;
        user = "teto";
      };
    };
    layout = "fr";
    # TODO swap esc/shift
    xkbOptions = "eurosign:e";
    # xkbOptions = "eurosign:e, caps:swapescape";

    synaptics = {
      enable = true;
      twoFingerScroll = true;
      buttonsMap = [ 1 3 2 ];
      accelFactor = "0.0055";
      minSpeed = "0.95";
      maxSpeed = "1.55";
      palmDetect = true;
    };
    # ${pkgs.xorg.xset}/bin/xset r rate 200 50
    displayManager.sessionCommands = ''
    ${pkgs.networkmanagerapplet}/bin/nm-applet &
    '';
  };

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.xterm.enable = false;
  # extraSessionCommands / configFile
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3;

  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;

  # for nix-shell
  programs.bash.enableCompletion = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  users.extraUsers.teto = {
     isNormalUser = true;
     uid = 1000;
     extraGroups = ["wheel" "networkmanager"];
	 shell = pkgs.zsh;
  };
  nixpkgs.config = {
	allowUnfree = true;
    permittedInsecurePackages = [
          "webkitgtk-2.4.11"
            ];
  };

  # pkgs.lib.mkBefore
  # options.nix.nixPath.default
  # options.nix.nixPath.default ++
  nix.nixPath =   [
    "nixpkgs=/home/teto/nixpkgs"
    "nixos-config=/home/teto/dotfiles/nixpkgs/configuration.nix:/nix/var/nix/profiles/per-user/root/channels"
  ] ;

  system = {
    # stateVersion = "17.03"; # why would I want to keep that ?
    copySystemConfiguration = true;
    autoUpgrade = {
      channel= "https://nixos.org/channels/nixos-unstable";
      enable = false;
    };
  };
  # The NixOS release to be compatible with for stateful data such as databases.
  # system.stateVersion = "17.03";
  # literal example
  # system.requiredKernelConfig = with config.lib.kernelConfig; [
  #         (isYes "MODULES")
  #         (isEnabled "FB_CON_DECOR")
  #         (isEnabled "BLK_DEV_INITRD")
  #       ]

}
