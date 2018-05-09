{ config, lib, pkgs,  ... }:
let
  userNixpkgs = /home/teto/nixpkgs;
  nixosConfig = /home/teto/dotfiles/configuration.nix;
  in
{



  imports = [
    # todo renommer en workstation
    # ./hardware-dell.nix
    /etc/nixos/hardware-configuration.nix

    ./modules/ntp.nix
    ./modules/network-manager.nix
    ./modules/xserver.nix
    ./modules/wireshark.nix
    ./modules/wifi.nix
    # ./desktopPkgs.nix
    # ./modules/tor.nix

  ];


  # kernelModules
  # lib.mkMerge
  boot.initrd.availableKernelModules =  [
    # TODO make them default
        # Support USB keyboards, in case the boot fails and we only have
        # a USB keyboard.
        "uhci_hcd"
        "ehci_hcd"
        "ehci_pci"
        "ohci_hcd"
        "xhci_hcd"
        "usbhid"
        "hid_generic" 
  ];

  networking.firewall.checkReversePath = false; # for nixops
  networking.firewall.allowedUDPPorts = [ 631 ];
  networking.firewall.allowedTCPPorts = [ 631 ];

  # allow-downgrade falls back when dnssec fails, "true" foces dnssec
  services.resolved.dnssec = "allow-downgrade";

  # this is for gaming
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio = {
    enable = true;
    systemWide = false;
    # daemon.config
    support32Bit = true;
  };

  # Select internationalisation properties.
  i18n = {
     consoleFont = "Lat2-Terminus16";
     consoleKeyMap = "fr";
     defaultLocale = "fr_FR.UTF-8";
     # can generate problems for wireshark with Qt versions
     inputMethod = {
       enabled = "fcitx";
       fcitx.engines = with pkgs.fcitx-engines; [
         mozc
         # hangul
         # m17n
         # libpinyin
        # chewing
        # unikey
        # anthy
        # cloudpinyin
     ];
     };

     # see https://github.com/NixOS/nixpkgs/issues/22895
     # consoleUseXkbConfig = "fr";
   };

   # inspired by https://gist.github.com/539h/8144b5cabf97b5b206da
   # todo find a good japanese font
   fonts = {
      enableFontDir = true; # ?
      fonts = with pkgs; [
        ubuntu_font_family
        inconsolata # monospace
        noto-fonts-cjk # asiatic
        nerdfonts
        corefonts # microsoft fonts 
        dejavu_fonts
        # Adobe Source Han Sans
        sourceHanSansPackages.japanese
        fira-code-symbols # for ligatures in neovim-gtk
        # noto-fonts
      ];
      fontconfig= {
        enable=true;
      };
   };

  # udisks2 GUI
  services.udisks2.enable = true;


  services.strongswan = {
    enable = true;
      # "/etc/ipsec.d/*.secrets" "/etc/ipsec.d"
    secrets = ["/etc/ipsec.d"];
  };

  services.mpd = {
    enable = false; # TODO move to userspace
    # musicDirectory
  };

  services.xserver.windowManager.awesome = {
    enable = true;
    luaModules = [];
  };

  # to change owner of setuid binaries like ping 
  # security.wrappers

  # services.xserver.xrandrHeads = ;

  # seemingly working for chromium only, check for firefox
  programs.browserpass.enable = true;


  # environment.systemPackages = with pkgs; [
  #   dhcp # to have dhclient in PATH
  # ];

  nix = {

    # just to test for now
    package = pkgs.nixStable;
    # package = pkgs.nixUnstable;

    buildCores=4;
    nixPath = [
      "nixos-unstable=https://github.com/nixos/nixpkgs-channels/archive/nixos-unstable.tar.gz"
      "nixos=https://github.com/nixos/nixpkgs-channels/archive/nixos-18.03.tar.gz"
    ]
    ++ lib.optionals (builtins.pathExists userNixpkgs)  [ "nixpkgs=${builtins.toString userNixpkgs}" ]
    ++ lib.optionals (builtins.pathExists nixosConfig)  [ "nixos-config=${builtins.toString nixosConfig}" ]
    ;
    #  to keep build-time dependencies around => rebuild while being offline
    # build-use-sandbox = true
    # 
    extraOptions = ''
      # careful will prevent from fetching local git !
      build-use-sandbox = true
      gc-keep-outputs = true
      # http-connections = 25 is the default
      http2 = true
      keep-derivations = true
      keep-failed = true
      show-trace = true
    '';

    # either use --option extra-binary-caches http://hydra.nixos.org/
    # nix.binaryCaches = [ http://hydra.nixos.org/ ];
    # handy to hack/fix around
    readOnlyStore = false;
  };

}

