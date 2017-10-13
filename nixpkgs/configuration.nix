#  vim: set et fdm=marker fenc=utf-8 ff=unix sts=2 sw=2 ts=4 :
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, lib, ... }:

let
  # hopefully it can be generated as dirname <nixos-config>
  configDir = /home/teto/dotfiles/nixpkgs;
  userNixpkgs = /home/teto/nixpkgs;

  # TODO to get
  # mynixpkgs = import nixRepo {};
  # nixRepo = pkgs.fetchFromGitHub {
  #   owner = "teto";
  #   repo = "teto";
  #   rev = "aa3535cee57479a8f0721c3e05c4e91966ecdcd6";
  #   sha256 = "0h9x8vdw0rrnkrnhljc8mm3zbi27nk8f9q7nkm9rv5mjkrzn67ng";
  # };
  # then install mynixpkgs.pkg
in
rec {


  networking.hostName = "jedha"; # Define your hostname.

  
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ./mptcp-kernel.nix
      ./basetools.nix
      ./extraTools.nix
      ./desktopPkgs.nix
      # symlink towards a config
    ] ++ lib.optionals (builtins.pathExists ./machine-specific.nix) [ ./machine-specific.nix ];

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


  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.firewall.checkReversePath = false; # for nixops

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
  environment.systemPackages = [

    pkgs.strongswan
    # networkmanager_strongswan
      # wrapProgram $out/bin/dnschain --suffix PATH : ${openssl.bin}/bin
  # let
  #   # basePkgs = import "${configDir}/basetools.nix" pkgs;
  #   desktopPkgs = import "${configDir}/desktopPkgs.nix" pkgs;
  #   # networkPkgs = import "${configDir}/desktopPkgs.nix";
  # in desktopPkgs ++ [
  # TODO put some of the packages into an "extraPackages" set
  # or pin it to a binary version
    # astroid # might require a rebuild of webkit => too big
    # gnomecontrolcenter
    # cups-pk-helper # to add printer through gnome control center
   ];

   # TODO it appears in /etc/bashrc !
   # TODO look up $ZDOTDIR/aliases.sh
   environment.shellAliases = {
     # TODO won't work in bash
    # nixpaste="curl -F 'text=<-' http://nixpaste.lbr.uno";

      # git variables {{{
      gl="git log";
      gs="git status";
      gd="git diff";
      ga="git add";
      gc="git commit";
      gcm="git commit -m";
      gca="git commit -a";
      gb="git branch";
      gch="git checkout";
      grv="git remote -v";
      gpu="git pull";
      gcl="git clone";
      gta="git tag -a -m";
      gbr="git branch";
      # }}}

      # nix aliases {{{
      nxi="nix-env -iA";
      nxu="nix-env -e";
      nxs="nix-shell -A";
      nxp="nixops ";
      # }}}

# Mail {{{
# todo use nix-shell
#  ml="python2.7 -malot -n ~/.config/notmuch/notmuchrc_pro"
#  mg="python2.7 -malot -n ~/.config/notmuch/notmuchrc"
#  astroperso="astroid"
#  astropro="astroid -c ~/.config/astroid/config_pro"
# }}}

   };


   # let's be fucking crazy
   environment.enableDebugInfo = true;

  # variables set by PAM
  environment.sessionVariables = {};

  environment.variables = {
    EDITOR="nvim";
    BROWSER="qutebrowser";
    XDG_CONFIG_HOME="$HOME/.config";
    XDG_CACHE_HOME="$HOME/.cache";
    XDG_DATA_HOME="$HOME/.local/share";
  # TODO Move to user config aka homemanager
    ZDOTDIR="$XDG_CONFIG_HOME/zsh";
    # HISTFILE="$XDG_CACHE_HOME/bash_history";
    LESS=""; # options to pass to less automatically
  };
  # stick to sh as it's shell independant
  # load fzf-share
  environment.extraInit = ''
    # TODO source fzf
    '';

  # List services that you want to enable:
  services = {
    gnome3 = {
      gnome-keyring.enable = true;
      seahorse.enable = true;
      at-spi2-core.enable = true; # for keyring it seems
	  gnome-disks.enable = false;
    };

    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint ];
    };

    openssh = {
      permitRootLogin = "no";
    enable = false;
    };
    locate.enable = true;

    # dbus.packages = [ ];
  };

  # udisks2 GUI
  services.udisks2.enable = true;

  services.openntpd = {
    enable = true;
    # add iij ntp servers
    # servers
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
      # job.logXsession = true; # writes into ~/.xsessions-errors
      # enableCtrlAltBackspace = false;
      # exportConfiguration = false;
      # for the smaller setup setup the favorite mode to 1920 x 1080
       # screenSection = '' '';
    };

    layout = "fr";
    # TODO swap esc/shift
    xkbOptions = "eurosign:e";
    # xkbOptions = "eurosign:e, caps:swapescape";

    libinput = {
      enable = true;
      # twoFingerScroll = true;
      disableWhileTyping = true;
      naturalScrolling = false;
      # accelSpeed = "1.55";
    };

    # todo run greenclip 
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


  services.mpd = {
    enable = true;
    # musicDirectory
  };

  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.enableAutosuggestions = true;
  programs.zsh.syntaxHighlighting.enable = false;
  # programs.zsh.shellAliases
  programs.zsh.shellAliases= environment.shellAliases // {
    se="sudoedit";
  # ++ [
# alias -s html=qutebrowser
# alias -s json=nvim
# alias -s Vagrantfile=nvim
# alias -s py=python3
# alias -s rb=ruby
# alias -s png=sxiv
# alias -s jpg=xdg-open
# alias -s gif=xdg-open
# alias -s avi=mpv
# alias -s mp3=mocp
# alias -s pdf=xdg-open
# alias -s doc=xdg-open
# alias -s docx=xdg-open
  };

  # for nix-shell
  programs.bash.enableCompletion = true;

  programs.adb.enable = true;

  # for nixops
  virtualisation.libvirtd.enable = true;
  programs.wireshark.enable = true; # installs setuid
  programs.wireshark.package = pkgs.wireshark; # which one


  # seemingly working for chromium only, check for firefox
  programs.browserpass.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # per-user package is quite cool too
  # https://github.com/NixOS/nixpkgs/pull/25712/files
  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  # when set to false, /etc/passwd and /etc/group will be congruent to your NixOS configuration
  # users.mutableUsers = false;
  users.extraUsers.teto = {
     isNormalUser = true; # creates home/ sets default shell
     uid = 1000;
     extraGroups = [
       "wheel" # for sudo
       "networkmanager"
       "libvirtd" # for nixops
       "adbusers" # for android tools
       "wireshark"
       "plugdev" # for udiskie
     ];
     # once can set initialHashedPassword too
     initialPassword = "test";
	 shell = pkgs.zsh;
     # TODO import it from desktopPkgs for instance ?
     packages = [
       pkgs.termite pkgs.sxiv pkgs.firefox
        pkgs.qutebrowser
     ];
  };

  # you can use http instead
  # nix.sshServe = {
  #   enable  = true;
  #   keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDmt8RlXKAn7zryenWl8e8RDLZ+WLzIsdqwDMbvynF/Eg3zraxWpm80cXlIrGAayHf8eTjmWXoDnWBuS3MHjv9nTWHliJVyHC5/aImrGflkGpWWpBvxg79bIz06QusqBx4Vfq6NKn/GS6L8KevhtMToLmEOyRuB3Gs1FWsHb/EbqKp5hzDYS3yVMjVkF+cubQiK/DEvcio/G/vSDrBcPE8kUZcf3ibsBruUa3tCh4RTmaLnoIbkOX/ColTWPIOhMlnYeOOzZ22ln6cgBgarjU/DEpb4iu0qSjTArNV58mUpqzEUU0sTq2sunK0hdEDkxWw/3qpv6MI276AQ4QrY2wTN teto@jedha" ];
  # };

  nixpkgs.config = {
	allowUnfree = true;
    # permittedInsecurePackages = [
    #       "webkitgtk-2.4.11"
    #         ];
    firefox.enableAdobeFlash = true;
    chromium.enablePepperFlash = true;
    # programs.chromium.enableAdobeFlash = true; # for Chromium

  };


  # pkgs.lib.mkBefore
  # options.nix.nixPath.default
  # todo set it only if path exists
  nix.nixPath =   [
    "nixos-config=/home/teto/dotfiles/nixpkgs/configuration.nix:/nix/var/nix/profiles/per-user/root/channels"
  ]
  ++ lib.optionals (builtins.pathExists userNixpkgs)  [ "nixpkgs=${builtins.toString userNixpkgs}" ]
  ;

  # handy to hack/fix around
  # nix.readOnlyStore = false;

  system = {
    # stateVersion = "17.03"; # why would I want to keep that ?
    copySystemConfiguration = true;
    autoUpgrade = {
      channel= "https://nixos.org/channels/nixpkgs-unstable";
      enable = true;
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
