{ config, lib, pkgs,  ... }:
let
  secrets = import ./secrets.nix;
  # # https://nixos.org/channels/nixos-unstable
  unstable = import <nixos-unstable> { inherit config; };
in
{
  imports = [
    # todo renommer en workstation
   ./hardware-lenovo.nix

    # for nova dev
    ./modules/docker-daemon.nix
    ./profiles/nova-dev.nix

    # ./modules/distributedBuilds.nix
    ./modules/config-all.nix
    ./modules/desktop.nix
    ./modules/network-manager.nix
    # ./modules/libvirtd.nix
    # ./modules/vpn.nix
    # ./modules/openssh.nix
    ./modules/hoogle.nix
    # ./modules/tor.nix
    ./modules/nova.nix

    # ./modules/sway.nix

    # not needed ?
    # ./modules/hwrng.nix

    # ihaskell marked as broken :'(
    # ./modules/jupyter.nix
  #   ./modules/mininet.nix

    # extra module not upstreamed yet
    # makes it crash
    # ({ config, lib, ... }:
    # {
    #   _file = "matt";
    #   # boot.kernel.checkPackageConfig = true;
    # })

    # TODO use from flake or from unstable
    # ./modules/mptcp.nix
  ]
  ;

  users.users.teto.packages = with pkgs; [
    pciutils # for lspci
    ncdu  # to see disk usage
    # bridge-utils # pour  brctl
    wirelesstools # to get iwconfig
    gitAndTools.diff-so-fancy
    # aircrack-ng
  ];

  # nesting clones can be useful to prevent GC of some packages
  # https://nixos.org/nix-dev/2017-June/023967.html


  # system.requiredKernelConfig 

#  fileSystems."/mnt/ext" =
 #   { device = "/dev/sda4";
  #  options = [ "user" "exec" ];
   # };

  # it apparently still is quite an important thing to have
  boot.devSize = "5g";

  # to make it work with 5.3
  boot.zfs.enableUnstable = true;

  # TODO look at
  # boot.specialFileSystems.


  # necessary for qemu  to prevent
# client> qemu-img: Error while writing to COW image: No space left on device
#   * client: command ‘['qemu-img', 'rebase', '-f', 'qcow2', '-b', '', '/run/user/1000/nixops-tmpV3FOyf/disk-client.qcow2']’ failed on machine ‘client’ (exit code 1)
  # NOTE: this doesn't change the size of /run/user see https://nixos.org/nix-dev/2015-July/017657.html
  boot.runSize = "10g";

  swapDevices = [{
    # label = "dartagnan";
    device = "/fucking_swap";
    # size = 8192; # in MB
    size = 4096; # in MB
    # size = 16000; # in MB
  } ];

  boot.blacklistedKernelModules = [
    # "nouveau"
  ];

  boot.consoleLogLevel=6;
  boot.loader = {
#    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true; # allows to run $ efi...
    systemd-boot.editor = true; # allow to edit command line
    timeout = 5;
    # just to generate the entry used by ubuntu's grub
    grub = {
      enable = true;
      useOSProber = true;
  # boot.loader.grub.version = 2;
    # install to none, we just need the generated config
    # for ubuntu grub to discover
      device = "/dev/sdb";


    };
  };

  # hide messages !
  # boot.kernelParams = [ "earlycon=ttyS0" "console=ttyS0" ];

  # DOES NOT WORK !
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_testing;

  boot.kernelModules =  [
    "af_key" # for ipsec/vpn support
    "kvm"
    "kvm-intel" # for virtualisation
  ];
  # boot.extraModulePackages = with config.boot.kernelPackages; [ wireguard ];

  boot.kernel.sysctl = {
    # to not provoke the kernel into crashing
    # "net.ipv4.tcp_timestamps" = 0;
    "net.ipv4.ipv4.ip_forward" = 1;
    # "net.ipv4.tcp_keepalive_time" = 60;
    # "net.core.rmem_max" = 4194304;
    # "net.core.wmem_max" = 1048576;
  };

  networking.hostName = "jedha"; # Define your hostname.

  # TODO add the chromecast
  networking.firewall.allowedUDPPorts = [ ];
  # networking.firewall.allowedTCPPorts = [ 8080 ];

  # temporary while working on result-store
  networking.firewall.allowedTCPPorts = [ 5000 52002 ];

  # creates problem with buffalo check if it blocks requests or what
  # it is necessary to use dnssec though :(
  networking.resolvconf.dnsExtensionMechanism = false;
  networking.resolvconf.dnsSingleRequest = false;

  # networking.interfaces = {
  #     # macAddress = "3B-0B-B5-6A-ED-91";
  #     eno1 = {
  #       name = "proxy"; useDHCP=true;  mtu=1500;
  #       # I just want to use 
  #       ipv4.routes = [
  #         { address = "10.0.0.0"; prefixLength = 16; }
  #         # { address = "192.168.2.0"; prefixLength = 24; via = "192.168.1.1"; }
  #       ];
  #     };
  #     # eth1 = { name = "eth1"; useDHCP=true; };
  # };


  # to allow wireshark to capture from netlink
  # networking.localCommands = ''
  #   ip link show nlmon0
  #   if [ $? -ne 0 ]; then
  #     ip link add nlmon0 type nlmon
  #     ip link set dev nlmon0 up
  #   fi
  # '';

  # programs.seahorse.enable = false; # UI to manage keyrings

  # List services that you want to enable:
  services = {
    gnome3 = {
      gnome-keyring.enable = true;
      at-spi2-core.enable = true; # for keyring it seems
    };

    # Enable CUPS to print documents.
    # https://nixos.wiki/wiki/Printing
    printing = {
      enable = true;
      browsing = false;
      drivers = [
        pkgs.gutenprint pkgs.gutenprintBin
        # See https://discourse.nixos.org/t/install-cups-driver-for-brother-printer/7169
        pkgs.brlaser
      ];
    };

    # just locate
    locate.enable = true;
    # dbus.packages = [ ];
  };

      # overlays =
      # let path = ../overlays; in with builtins;
      # map (n: import (path + ("/" + n)))
      #     (filter (n: match ".*\\.nix" n != null ||
      #                 pathExists (path + ("/" + n + "/default.nix")))
      #             (attrNames (readDir path)))
      # ++ [ (import ./envs.nix) ];

  # nixpkgs.overlays = [
  #   # (import <nixpkgs-overlays/kernels.nix>)
  #   # (import ./overlays/haskell.nix) 
  # ];

  # for sublime text
  # nixpkgs.config.allowUnfree = true;

  # <nixos-overlay>
  # just for testing
  # services.qemuGuest.enable = true;

  security.sudo.extraConfig = ''
    Defaults        timestamp_timeout=30
  '';


  networking.enableIPv6 = false;

  services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia.package


  nix = {
    sshServe = {
      enable = true;
      protocol = "ssh";
      # keys = [ secrets.gitolitePublicKey ];
    };


    # added to nix.conf
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    distributedBuilds = false;
    package = pkgs.nixFlakes;
    # package = pkgs.nixUnstable;
  };

  # kind of a test
  # security.pam.services.lightdm.enableGnomeKeyring = true;

  # will fial until openflowswitch is fixed
  programs.mininet.enable = false;

  # networking.mptcp = {
  #   enable = true;
  #   debug = true;
  #   pathManager = "netlink";
  #   package = pkgs.linux_mptcp_trunk_raw;
  # };

  services.greenclip.enable = true;

  # ebpf ?
  # broken in https://github.com/NixOS/nixpkgs/issues/56724
  # programs.bcc.enable = true;

  environment.systemPackages = with pkgs;
    # cups-pk-helper # to add printer through gnome control center
    [
    ]
  ;

  # services.squid.enable = true;
  # proxyPort

  # see https://github.com/NixOS/nixpkgs/pull/45345
  # switch to it via
  # sudo /run/current-system/fine-tune/child-1/bin/switch-to-configuration test
  # nesting.clone = [
  #     {
  #       imports = [
  #         ./modules/proxy.nix
  #       ];
  #       boot.loader.grub.configurationName = "with proxy";
  #       # networking.proxy.default = "http://proxy.work.com:80";
  #       # networking.proxy.noProxy = "127.0.0.1,localhost,work.com";
  #       # nix.binaryCaches = [
  #       #         "http://nixcache.work.com"
  #       #         "https://cache.nixos.org"
  #       # ];
  #     }
  # ];


  # services.xserver.displayManager.gdm.nvidiaWayland = true;

  # this is required as well
  hardware.nvidia.modesetting.enable = true;

  # security.sudo.wheelNeedsPassword = ;

       # system.replaceRuntimeDependencies
       #     List of packages to override without doing a full rebuild. The original derivation and replacement derivation must have the same name length, and ideally should have close-to-identical directory layout.

# system.userActivationScripts
  # system.copySystemConfiguration = true;
  # see https://www.mail-archive.com/nix-commits-bounces@lists.science.uu.nl/msg04507.html

  # kinda experimental
  # services.openssh.banner = "Hello world";
  security.rngd.enable = true;
  # security.rngd.debug = true;

  # marked as internal
  # $out here is the profile generation
  system.extraSystemBuilderCmds = ''
    ln -s ${config.boot.kernelPackages.kernel.dev}/vmlinux $out/vmlinux
  '';

  # # TODO this doesn't seem taken into account
  # services.xserver.displayManager.lightdm.autoLogin = {
  #   enable = true;
  #   user = "teto";
  # };

  # environment.ld-linux = true;
}
