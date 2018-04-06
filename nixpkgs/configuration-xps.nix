{ config, lib, pkgs,  ... }:
let
  secrets = import ./secrets.nix;
  # hopefully it can be generated as dirname <nixos-config>
  configDir = /home/teto/dotfiles/nixpkgs;
  userNixpkgs = /home/teto/nixpkgs;

  in
{
  imports = [
    # todo renommer en workstation
    # ./hardware-dell.nix
    /etc/nixos/hardware-configuration.nix

    ./common.nix
    ./xserver.nix
    ./libvirtd.nix
    ./network-manager.nix

    # for user teto
    ./extraTools.nix
    ./wireshark.nix
    ./wifi.nix
    # ./desktopPkgs.nix
    ./tor.nix

    # just to test
    ./modules/qemu-guest-agent.nix
  ]
  # ++ lib.optional (services ? jupyter)  ./jupyter.nix
  ;

  # it apparently still is quite an important thing to have
  boot.devSize = "5g";
  swapDevices = [{
    # label = "dartagnan";
    device = "/fucking_swap";
    # size = 8192; # in MB
    size = 16000; # in MB
  } ];

  boot.loader ={
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true; # allows to run $ efi...

  # just to generate the entry used by ubuntu's grub
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # install to none, we just need the generated config
  # for ubuntu grub to discover
    grub.device = "/dev/sda";
  };

  boot.kernelParams = [ " console=ttyS0" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # TODO we need nouveau 
  boot.kernelModules = [
    "af_key" # for ipsec/vpn support
    "kvm" "kvm-intel" # for virtualisation
  ];

  boot.kernel.sysctl = {
    # to not provoke the kernel into crashing
    "net.ipv4.tcp_timestamps" = 0;
    "net.ipv4.ipv4.ip_forward" = 1;
    # "net.ipv4.tcp_keepalive_time" = 60;
    # "net.core.rmem_max" = 4194304;
    # "net.core.wmem_max" = 1048576;
  };

  networking.hostName = "jedha"; # Define your hostname.

  # TODO add the chromecast
  networking.firewall.allowedUDPPorts = [ ];
  # creates problem with buffalo check if it blocks requests or what
  # it is necessary to use dnssec though :(
  networking.dnsExtensionMechanism = false;
  networking.dnsSingleRequest = false;
  networking.extraHosts = secrets.extraHosts;

  # this is for gaming
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio = {
    enable = true;
    systemWide = false;
    # daemon.config
    support32Bit = true;
  };

  # List services that you want to enable:
  services = {
    gnome3 = {
      gnome-keyring.enable = true;
      seahorse.enable = true; # UI to manage keyrings
      at-spi2-core.enable = true; # for keyring it seems
	  gnome-disks.enable = false;
    };

    # Enable CUPS to print documents.
    # https://nixos.wiki/wiki/Printing
    printing = {
      enable = true;
      browsing = true;
      drivers = [ pkgs.gutenprint ];
    };


    # just locate
    locate.enable = true;

    # dbus.packages = [ ];
  };

  environment.systemPackages = with pkgs;
    (import ./basetools.nix { inherit pkgs;})
    # strongswan # to get ipsec in path
    # cups-pk-helper # to add printer through gnome control center
    # 
    ++ [
      ]
  ;

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
        # noto-fonts
      ];
      fontconfig= {
        enable=true;
      };
   };

  # udisks2 GUI
  services.udisks2.enable = true;

  # to install as a user service
  # maybe remove ?
  # services.offlineimap.install = false;

  nix = {
    buildCores=4;
    nixPath = [
      "nixos-config=/home/teto/dotfiles/nixpkgs/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
      "/nix/var/nix/profiles/per-user/teto/channels"
      ""
    ]
    ++ lib.optionals (builtins.pathExists userNixpkgs)  [ "nixpkgs=${builtins.toString userNixpkgs}" ]
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

  services.strongswan = {
    enable = true;
      # "/etc/ipsec.d/*.secrets" "/etc/ipsec.d"
    secrets = ["/etc/ipsec.d"];
  };

  services.mpd = {
    enable = false; # TODO move to userspace
    # musicDirectory
  };

  # just to test for now
  nix.package = pkgs.nixUnstable;

  # to change owner of setuid binaries like ping 
  # security.wrappers

  # services.xserver.xrandrHeads = ;

  # seemingly working for chromium only, check for firefox
  programs.browserpass.enable = true;

  programs.ccache.enable = true;

  # https://github.com/NixOS/nixpkgs/issues/20548#issuecomment-377655713
  programs.zsh.enable = true;

  # use with nix-locate to find a file across packages
  # DOES NOT EXIST YET :'(
  # programs.nix-index.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # per-user package is quite cool too
  # https://github.com/NixOS/nixpkgs/pull/25712/files
  # This can be either a full system path or a shell package
  # users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  users.defaultUserShell = pkgs.zsh;

  # when set to false, /etc/passwd and /etc/group will be congruent to your NixOS configuration
  # users.mutableUsers = false;

  # let's be fucking crazy
  # environment.enableDebugInfo = true;
}
