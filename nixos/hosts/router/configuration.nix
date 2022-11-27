/*
the router is an APU4D4, i.e., x86-based system
https://teklager.se/en/products/routers/apu4d4-open-source-router

Links of interest:
- https://dataswamp.org/~solene/2022-08-03-nixos-with-live-usb-router.html
- https://skogsbrus.xyz/blog/2022/06/12/router/
- https://francis.begyn.be/blog/nixos-home-router
- https://www.jjpdev.com/posts/home-router-nixos/

When booting, hit tab to edit the boot entry. 
Normally NixOS does not output to serial in the boot process, so we need to enable is by appending console=ttyS0,115200 to the boot entry. All characters appear twice, so just make sure you type it correctyl ;) . ctrl+l can be used to refresh the screen. 
 After installing, you want to make sure that the PCEngine APU entry from the NixOS hardware repo is present, as it enables the console port.
*/
{ config, lib, pkgs,  ... }:
let
  secrets = import ../../../nixpkgs/secrets.nix;

  bridgeNetwork = { address = "10.0.0.0"; prefixLength = 24; };

  # bridgeNetwork = "10.0.0.0";
in
{
  # pcengines/apu/
  imports = [
	./hardware.nix
    ../../modules/config-all.nix
    ../../profiles/openssh.nix
    ../../profiles/router.nix
      
    # TODO import from https://github.com/NixOS/nixos-hardware/tree/master/pcengines/apu
    # pcengines/apu
  #   ./modules/mininet.nix

  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # for the live cd
  # isoImage.squashfsCompression = "zstd -Xcompression-level 5";

  users.users.teto.packages =  [
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

  # to allow wireshark to capture from netlink
  # networking.localCommands = ''
  #   ip link show nlmon0
  #   if [ $? -ne 0 ]; then
  #     ip link add nlmon0 type nlmon
  #     ip link set dev nlmon0 up
  #   fi
  # '';

# networking = {
#   useDHCP = false;
#   # nameserver = [ "<DNS IP>" ];
#   # Define VLANS
#   vlans = {
#     wan = {
#       id = 10;
#       interface = "enp1s0";
#     };
#     lan = {
#       id = 20;
#       interface = "enp2s0";
#     };
#     # iot = {
#     #   id = 90;
#     #   interface = "enp2s0";
#     # };
#   };

#   interfaces = {
#     # Don't request DHCP on the physical interfaces
#     enp1s0.useDHCP = false;
#     enp2s0.useDHCP = false;
#     enp3s0.useDHCP = false;

#     # Handle the VLANs
#     wan.useDHCP = true;
#     # lan = {
#     #   ipv4.addresses = [{
#     #     address = "10.1.1.1";
#     #     prefixLength = 24;
#     #   }];
#     # };
#   };
# };


  powerManagement.cpuFreqGovernor = "ondemand";

  # TODO why copy solene's blog explanation
  # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.kernelParams = [
   "copytoram"
   "console=ttyS0,115200"
  ];
  boot.supportedFilesystems = pkgs.lib.mkForce [ "btrfs" "vfat" "xfs" "ntfs" "cifs" ];

  services.irqbalance.enable = true;

  networking.hostName = "coruscante";
  networking.dhcpcd.enable = false;
  networking.usePredictableInterfaceNames = true;
  networking.firewall.interfaces.enp1s0.allowedTCPPorts = [ 4949 ];
  networking.firewall.interfaces.br0.allowedTCPPorts = [ 53 ];
  networking.firewall.interfaces.br0.allowedUDPPorts = [ 53 ];

  security.sudo.wheelNeedsPassword = false;

  services.acpid.enable = true;
  services.openssh.enable = true;

  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [ "127.0.0.1" "10.42.42.42" ];
        access-control =  [
          "0.0.0.0/0 refuse"
          "127.0.0.0/8 allow"
          "10.42.42.0/24 allow"
        ];
      };
    };
  };

  # services.miniupnpd = {
  #     enable = true;
  #     externalInterface = "enp1s0";
  #     internalIPs = [ "br0" ];
  # };

  # services.munin-node = {
  #     enable = true;
  #     extraConfig = ''
  #     allow ^63\.12\.23\.38$
  #     '';
  # };

  networking = {
    defaultGateway = { address = "192.168.1.1"; interface = "wlp5s0"; };
    interfaces.enp1s0 = {
        ipv4.addresses = [
            { address = "192.168.1.127"; prefixLength = 24; }
        ];
    };

    interfaces.br0 = {
        ipv4.addresses = [
		  bridgeNetwork
            # { address = "10.42.42.42"; prefixLength = 24; }
        ];
    };

    bridges.br0 = {
        interfaces = [ "eth1" "eth2" ];
    };

    nat.enable = true;
    nat.externalInterface = "enp1s0";
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
      option routers ${bridgeNetwork.address};
      option domain-name-servers 10.42.42.42, 9.9.9.9;
      subnet 10.42.42.0 netmask 255.255.255.0 {
          range 10.42.42.100 10.42.42.199;
      }
      '';
      interfaces = [ "br0" ];
  };

  time.timeZone = "Europe/Paris";

  users.mutableUsers = false;
  # networking.enableIPv6 = false;
}
