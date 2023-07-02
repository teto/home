/*
  the router is an APU4D4, i.e., x86-based system
  https://teklager.se/en/products/routers/apu4d4-open-source-router

  Links of interest:
  - https://dataswamp.org/~solene/2022-08-03-nixos-with-live-usb-router.html
  - https://skogsbrus.xyz/blog/2022/06/12/router/
  - https://francis.begyn.be/blog/nixos-home-router
  - https://www.jjpdev.com/posts/home-router-nixos/

systemd is advertised on the matrix:nixos-router so:
  - the guide https://nixos.wiki/wiki/Systemd-networkd

  When booting, hit tab to edit the boot entry. 
  Normally NixOS does not output to serial in the boot process, so we need to enable is by appending console=ttyS0,115200 to the boot entry. All characters appear twice, so just make sure you type it correctyl ;) . ctrl+l can be used to refresh the screen. 
   After installing, you want to make sure that the PCEngine APU entry from the NixOS hardware repo is present, as it enables the console port.
*/
{ config, lib, pkgs, ... }:
let
  secrets = import ../../nixpkgs/secrets.nix;

  bridgeNetwork = { address = "10.0.0.0"; prefixLength = 24; };

  # todo rely on a lib to manipulate network
  show = at:
    "${at.address}/${toString at.prefixLength}";

  externalInterface = "wlp5s0";

  # bridgeNetwork = "10.0.0.0";
in
{
  # pcengines/apu/
  imports = [
    ./hardware.nix
    ../config-all.nix
    ./openssh.nix
    ../../nixos/profiles/router.nix
    # TODO use ${modulePath} instead
    # self.inputs.nixos-hardware.nixosModules.pcengines-apu 

    # TODO import from https://github.com/NixOS/nixos-hardware/tree/master/pcengines/apu
    # pcengines/apu
  ];

  environment.systemPackages = with pkgs; [
    bridge-utils
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # for the live cd
  # isoImage.squashfsCompression = "zstd -Xcompression-level 5";

  users.users.teto.packages = [
    # pciutils # for lspci
    # ncdu  # to see disk usage
    # bridge-utils # pour  brctl
    # wirelesstools # to get iwconfig
    # aircrack-ng
  ];



  # boot.kernel.sysctl = {
  #   # to not provoke the kernel into crashing
  #   # "net.ipv4.tcp_timestamps" = 0;
  #   # "net.ipv4.ipv4.ip_forward" = 1;
  #   # "net.ipv4.tcp_keepalive_time" = 60;
  #   # "net.core.rmem_max" = 4194304;
  #   # "net.core.wmem_max" = 1048576;
  # };

  # # creates problem with buffalo check if it blocks requests or what
  # # it is necessary to use dnssec though :(
  # networking.resolvconf.dnsExtensionMechanism = false;
  # networking.resolvconf.dnsSingleRequest = false;

  powerManagement.cpuFreqGovernor = "ondemand";

  # TODO why copy solene's blog explanation
  # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.kernelParams = [
    "copytoram"
    "console=ttyS0,115200"
  ];
  boot.supportedFilesystems = pkgs.lib.mkForce [ "btrfs" "vfat" "xfs" "ntfs" "cifs" ];

  services.irqbalance.enable = true;

  networking.hostName = "router";
  # networking.dhcpcd.enable = true;
  networking.usePredictableInterfaceNames = true;
  # networking.firewall.interfaces.enp1s0.allowedTCPPorts = [ 4949 ];

  networking.firewall.interfaces.br0.allowedTCPPorts = [ 53 ];
  networking.firewall.interfaces.br0.allowedUDPPorts = [ 53 ];

  security.sudo.wheelNeedsPassword = false;

  services.acpid.enable = true;
  services.openssh = {
    enable = true;
    # kinda experimental
    # services.openssh.banner = "Hello world";
    # ports = [ 12666 ];
    # new format
    settings = {
      LogLevel = "VERBOSE";
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      # PermitRootLogin = "prohibit-password";
    };

  };

  services.unbound = {
    enable = false;
    settings = {
      server = {
        interface = [ "127.0.0.1" "10.42.42.42" ];
        access-control = [
          "0.0.0.0/0 refuse"
          "127.0.0.0/8 allow"
          "${show bridgeNetwork} allow"
        ];
      };
    };
  };

  # services.miniupnpd = {
  #     enable = true;
  #     externalInterface = "enp1s0";
  #     internalIPs = [ "br0" ];
  # };

  services.munin-node = {
      enable = true;
  #     extraConfig = ''
  #     allow ^63\.12\.23\.38$
  #     '';
  };


  # following the guide https://nixos.wiki/wiki/Systemd-networkd
  systemd.network = {
    enable = true;

   # example
   # systemd.network.links."10-custom_name" = {
   # matchConfig.MACAddress = "52:54:00:12:01:01";
   # linkConfig.Name = "custom_name";
   # };

    links = {
     "10-enp1s0" = {
       matchConfig.OriginalName = "enp1s0";
      # "ether", "loopback", "wlan", "wwan"
      # matchConfig.Type = "ether";
     };
     "10-wlp5s0" = {
       matchConfig.OriginalName = "wlp5s0";
      # "ether", "loopback", "wlan", "wwan"
      # matchConfig.Type = "ether";
     };

    };

    netdevs = {

     # man systemd.netdev
     "br0" = {
      # match
       netdevConfig.Name="br0";
       netdevConfig.Kind="bridge";
      # interfaces = [ "enp2s0" "enp3s0" "enp4s0" ];
      # bridgeConfig

     };

    };

    # [NetDev]
# Name=br0
# Kind=bridge

    networks = {
     "10-lan" = {
       matchConfig.Name = "lan";
       networkConfig.DHCP = "ipv4";
     };
     "br0" = {
       matchConfig.Name = "br0";
       # address = [ 
       # ];
       networkConfig.Address = "${bridgeNetwork.address}/${toString bridgeNetwork.prefixLength}";
          # routes = [
          #   { routeConfig = { Destination = "64:ff9b::/96"; Gateway = "2001:db8::1"; }; }
          # ];

       networkConfig.DHCP = "ipv4";


     };
    };
  };

  networking = {
    # address of the livebox
    defaultGateway = { address = "192.168.1.1"; interface = "wlp5s0"; };

    interfaces.enp1s0 = {
      useDHCP = true;
      # ipv4.addresses = [
      # { address = "192.168.1.127"; prefixLength = 24; }
      # ];
    };

    interfaces.wlp5s0 = {
      useDHCP = true;
      # ipv4.addresses = [
      # { address = "192.168.1.127"; prefixLength = 24; }
      # ];
    };

    interfaces.br0 = {
      ipv4.addresses = [
        bridgeNetwork
      ];
    };

    bridges.br0 = {
      interfaces = [ "enp2s0" "enp3s0" "enp4s0" ];
    };

    nat.enable = true;
    nat.externalInterface = externalInterface;
    nat.internalInterfaces = [ "br0" ];

    wireless = {
      enable = true;
      userControlled.enable = true;
      networks = {
        neotokyo = {
          psk = secrets.router.password;
        };
      };
    };
  };

  services.dhcpd4 = {
    enable = true;

    # TODO FIX
    extraConfig = ''
    option subnet-mask 255.255.255.0;
    # L'option routers spécifie une liste d'adresses IP de routeurs qui sont sur le sous-réseau du client. Les routeurs doivent être mentionnés par ordre de préférence.
    option routers ${bridgeNetwork.address};
    option domain-name-servers 192.168.1.1;
    subnet ${bridgeNetwork.address} netmask 255.255.255.0 {
        range 10.0.0.100 10.0.0.199;
    }
    '';
    interfaces = [ "br0" ];
  };

  time.timeZone = "Europe/Paris";

  users.mutableUsers = false;
  # networking.enableIPv6 = false;
}
