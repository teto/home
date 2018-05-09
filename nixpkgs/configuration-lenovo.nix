{ config, lib, pkgs,  ... }:
let
  secrets = import ./secrets.nix;
  # hopefully it can be generated as dirname <nixos-config>
  configDir = /home/teto/dotfiles/nixpkgs;

  in
{
  imports = [
    # todo renommer en workstation
    # ./hardware-dell.nix
    /etc/nixos/hardware-configuration.nix

    ./common-all.nix
    ./common-desktop.nix
    ./modules/network-manager.nix
    ./modules/libvirtd.nix


    # for user teto
    ./extraTools.nix
    # ./desktopPkgs.nix
  ] 
  # while developing
  # builtins.pathExists (<nixpkgs> + ./modules/programs/mininet.nix))
  ++ lib.optionals (false)
  [
    ./modules/mininet.nix
  ]
  ;

  # it apparently still is quite an important thing to have
  boot.devSize = "5g";

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
    size = 16000; # in MB
  } ];

  boot.consoleLogLevel=6;
  boot.loader ={
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true; # allows to run $ efi...
    systemd-boot.editor = true; # allow to edit command line
    timeout = 5;
  # just to generate the entry used by ubuntu's grub
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # install to none, we just need the generated config
  # for ubuntu grub to discover
    grub.device = "/dev/sda";
  };

  # hide messages !
  # boot.kernelParams = [ "earlycon=ttyS0" "console=ttyS0" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # TODO we need nouveau  ?
  # lib.mkMerge
  boot.kernelModules =  [
    "af_key" # for ipsec/vpn support
    "kvm" 
    "kvm-intel" # for virtualisation
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
  # networking.interfaces = {
  #     eth0 = { name = "eth0"; useDHCP=true; macAddress = "3B-0B-B5-6A-ED-91"; mtu=1500;};
  #     eth1 = { name = "eth1"; useDHCP=true; };
  # };


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

  # just for testing
  # services.qemuGuest.enable = true;

  # to prevent
  # The VirtualBox Linux kernel driver (vboxdrv) is either not loaded or there is a permission problem with /dev/vboxdrv. Please reinstall the kernel module by executing '/sbin/vboxconfig' as root.
  # virtualisation.virtualbox.host.enable = true;

  # services.telnet = {
  #   enable = true;
  #   openFirewall = true;
  #   # port = ;
  # };

  environment.systemPackages = with pkgs;
    (import ./basetools.nix { inherit pkgs;})
    # strongswan # to get ipsec in path
    # cups-pk-helper # to add printer through gnome control center
    # 
    ++ [
      ]
  ;
}