{ config, lib, pkgs,  ... }:
let
  secrets = import ./secrets.nix;
  userNixpkgs = /home/teto/nixpkgs;
  nixosConfig = ./configuration.nix;
  # nixosOverlay = /home/teto/dotfiles/nixpkgs/overlays;
  # with builtims.fetchGit , no need for that anymore ?
  sshFolder = /home/teto/.ssh/config;
in
{



  imports = [
    # todo renommer en workstation
    # ./hardware-dell.nix
    # /etc/nixos/hardware-configuration.nix
    ./config-all.nix

    ./modules/ntp.nix
    ./modules/network-manager.nix
    ./modules/xserver.nix
    ./modules/wireshark.nix
    ./modules/wifi.nix
    # ./modules/tor.nix

    # only if available
    # ./modules/jupyter.nix
  ];

  # boot.kernelModules = [ ];

  # kernelModules
  # lib.mkMerge
  # boot.initrd.availableKernelModules =  [
    # TODO make them default
        # Support USB keyboards, in case the boot fails and we only have
        # a USB keyboard.
        # "uhci_hcd"
        # "ehci_hcd"
        # "ehci_pci"
        # "ohci_hcd"
        # "xhci_hcd"
        # "usbhid"
        # "hid_generic"
  # ];

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
         table-other # for arabic
         table-extra # for arabic
         # hangul
         m17n
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
        # nerdfonts
        # corefonts # microsoft fonts  UNFREE
        font-awesome_5
        source-code-pro
        dejavu_fonts
        # Adobe Source Han Sans
        sourceHanSansPackages.japanese
        fira-code-symbols # for ligatures in neovim-gtk
        # noto-fonts
      ];

      fontconfig= {
        enable=true;
        antialias=true; # some fonts can be disgusting else
        allowBitmaps = false; # ugly
        includeUserConf = true;
        defaultFonts = {
          # monospace = [ "" ];
          # serif = [ "" ];
          # sansSerif =
        };
      };
   };

  # udisks2 GUI
  # services.udisks2.enable = true;

  # TODO check
  services.strongswan = {
    enable = true;
      # "/etc/ipsec.d/*.secrets" "/etc/ipsec.d"
    secrets = ["/etc/ipsec.d"];
  };

  services.mpd = {
    enable = false; # TODO move to userspace
    # musicDirectory
  };

  # TODO modify it to pass a function instead ?!
  services.xserver.windowManager.awesome = {
    enable = true;
    luaModules = [ pkgs.luaPackages.lpeg ];
  };

  # services.xserver.xrandrHeads = ;

  # seemingly working for chromium only, check for firefox
  programs.browserpass.enable = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
      firefox.enableBukubrow = true;
    };

    overlays = [
      # (import <nixpkgs-overlays/kernels.nix>)
      # (import <nixpkgs-overlays/haskell.nix>)
    ];
  };

  # services.hoogle = {
  #   enable = true;
  #   packages = (hpkgs: with hpkgs; [netlink]);
  #   port = 8090; # let 8080 for nix-serve
  #   # haskellPackages = pkgs.haskellPackages;
  # };

  nix = {
    # allowedUsers = [];

    buildCores=4;

    # This priority propagates to build processes. 0 is the default Unix process I/O priority, 7 is the lowest
    # daemonIONiceLevel = 3;
    # distributedBuilds = true;
    # TODO let it be set via channels ?
    # now with nix build -f channel:nixos-unstable
    # TODO use options.nix.nixPath.default ++
    nixPath = [
      "nixos-unstable=https://github.com/nixos/nixpkgs-channels/archive/nixos-unstable.tar.gz"
      "nixos=https://github.com/nixos/nixpkgs-channels/archive/nixos-19.03.tar.gz"
    ]
    ++ lib.optional (builtins.pathExists userNixpkgs)  "nixpkgs=${builtins.toString userNixpkgs}"
    ++ lib.optional (builtins.pathExists nixosConfig)  "nixos-config=${builtins.toString nixosConfig}"
    # ++ lib.optional (builtins.pathExists nixosOverlay) "nixpkgs-overlays=${builtins.toString nixosOverlay}"
    # ++ lib.optional (builtins.pathExists nixosOverlay) "ssh-config-file=${builtins.toString sshFolder}"
    ;

    # sshServe.enable = false;

    # careful will prevent from fetching local git !
    useSandbox = true;

    #  to keep build-time dependencies around => rebuild while being offline
    extraOptions = ''
      gc-keep-outputs = true
      # http-connections = 25 is the default
      http2 = true
      keep-derivations = true
      keep-failed = true
      show-trace = true
      builders-use-substitutes = true
    '';

    # generated via cachix use hie-nix
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://hie-nix.cachix.org"
    ];
    binaryCachePublicKeys = [
      "hie-nix.cachix.org-1:EjBSHzF6VmDnzqlldGXbi0RM3HdjfTU3yDRi9Pd0jTY="
    ];

    trustedUsers = [ "root" "teto" ];

    # either use --option extra-binary-caches http://hydra.nixos.org/
    # handy to hack/fix around
    # readOnlyStore = false;
  };

  # don't forget to run ulimit -c unlimited to get the actual coredump
  # then coredumpctl debug will launch gdb !
  systemd.coredump.enable = true;
  # security.pam.loginLimits

  # networking.extraHosts = secrets.extraHosts;

  system.copySystemConfiguration = true;

  # in master
  # xdg.autostart.enable

  users.users.teto = {
    shell = pkgs.zsh;
  };

}
