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

    ./common-desktop.nix
    # ./modules/libvirtd.nix
    ./modules/network-manager.nix

    # for user teto
    ./extraTools.nix
    ./modules/wireshark.nix
    # ./wifi.nix
    ./modules/tor.nix
    # ./desktopPkgs.nix
  ];

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
  # networking.extraHosts = secrets.extraHosts;

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


  # to install as a user service
  # maybe remove ?
  # services.offlineimap.install = false;

  services.strongswan = {
    enable = true;
      # "/etc/ipsec.d/*.secrets" "/etc/ipsec.d"
    secrets = ["/etc/ipsec.d"];
  };



}
