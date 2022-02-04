{ config, lib, pkgs,  ... }@args:
let
  secrets = import ./secrets.nix;
in
{
  imports = [
    ./modules/config-all.nix
    ./profiles/openssh.nix
    ./profiles/router.nix
      
    # TODO import from https://github.com/NixOS/nixos-hardware/tree/master/pcengines/apu
    # pcengines/apu
  #   ./modules/mininet.nix

  ];

  users.users.teto.packages = with pkgs; [
    # pciutils # for lspci
    # ncdu  # to see disk usage
    # bridge-utils # pour  brctl
    # wirelesstools # to get iwconfig
    # aircrack-ng
  ];

  # nesting clones can be useful to prevent GC of some packages
  # https://nixos.org/nix-dev/2017-June/023967.html

  # system.requiredKernelConfig 


  # it apparently still is quite an important thing to have
  # boot.devSize = "5g";

  # necessary for qemu  to prevent
  # NOTE: this doesn't change the size of /run/user see https://nixos.org/nix-dev/2015-July/017657.html
  # boot.runSize = "10g";

  # swapDevices = [{
  #   # label = "dartagnan";
  #   device = "/fucking_swap";
  #   size = 8192; # in MB
  #   # size = 4096; # in MB
  #   # size = 16000; # in MB
  # } ];

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
  boot.kernelParams = [
    # "earlycon=ttyS0"
    # "console=ttyS0" 
    # NECESSARY !! https://discourse.nixos.org/t/browsers-unbearably-slow-after-update/9414/30
     "intel_pstate=active"
  ];

  # DOES NOT WORK !
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelModules =  [
    "af_key" # for ipsec/vpn support
    # "kvm"
    # "kvm-intel" # for virtualisation
  ];
  # boot.extraModulePackages = with config.boot.kernelPackages; [ wireguard ];

  boot.kernel.sysctl = {
    # to not provoke the kernel into crashing
    # "net.ipv4.tcp_timestamps" = 0;
    # "net.ipv4.ipv4.ip_forward" = 1;
    # "net.ipv4.tcp_keepalive_time" = 60;
    # "net.core.rmem_max" = 4194304;
    # "net.core.wmem_max" = 1048576;
  };

  networking.hostName = "coruscante"; # Define your hostname.

  networking.firewall.allowedUDPPorts = [ ];
  # networking.firewall.allowedTCPPorts = [ 8080 ];

  # temporary while working on result-store
  networking.firewall.allowedTCPPorts = [ 5000 52002 ];

  # creates problem with buffalo check if it blocks requests or what
  # it is necessary to use dnssec though :(
  networking.resolvconf.dnsExtensionMechanism = false;
  networking.resolvconf.dnsSingleRequest = false;

  # to allow wireshark to capture from netlink
  # networking.localCommands = ''
  #   ip link show nlmon0
  #   if [ $? -ne 0 ]; then
  #     ip link add nlmon0 type nlmon
  #     ip link set dev nlmon0 up
  #   fi
  # '';

networking = {
  useDHCP = false;
  # nameserver = [ "<DNS IP>" ];
  # Define VLANS
  vlans = {
    wan = {
      id = 10;
      interface = "enp1s0";
    };
    lan = {
      id = 20;
      interface = "enp2s0";
    };
    # iot = {
    #   id = 90;
    #   interface = "enp2s0";
    # };
  };

  interfaces = {
    # Don't request DHCP on the physical interfaces
    enp1s0.useDHCP = false;
    enp2s0.useDHCP = false;
    enp3s0.useDHCP = false;

    # Handle the VLANs
    wan.useDHCP = true;
    # lan = {
    #   ipv4.addresses = [{
    #     address = "10.1.1.1";
    #     prefixLength = 24;
    #   }];
    # };
  };
};

  security.sudo.extraConfig = ''
    Defaults        timestamp_timeout=60
  '';

  # networking.enableIPv6 = false;
}

