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

    ./common-all.nix
    ./common-desktop.nix
    ./modules/libvirtd.nix

    # for user teto
    ./extraTools.nix

  ]
  # ++ lib.optional (services ? jupyter)  ./jupyter.nix
  ;
  
  # TODO conditionnally enable it
  # networking.proxy.default

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


  # to install as a user service
  # maybe remove ?
  # services.offlineimap.install = false;


  programs.ccache.enable = true;


  # use with nix-locate to find a file across packages
  # DOES NOT EXIST YET :'(
  # programs.nix-index.enable = true;

  # when set to false, /etc/passwd and /etc/group will be congruent to your NixOS configuration
  # users.mutableUsers = false;

  # let's be fucking crazy
  # environment.enableDebugInfo = true;
# } ++ lib.optionalAttrs (config.programs ? mininet) {

  programs.mininet.enable = true;

  # virtualisation.virtualbox = {
  #   host.enable = true;
  #   host.enableExtensionPack = true;
  #   host.addNetworkInterface = true; # adds vboxnet0
  #   # Enable hardened VirtualBox, which ensures that only the binaries in the system path get access to the devices exposed by the kernel modules instead of all users in the vboxusers group.
  #    host.enableHardening = true;
  #    host.headless = false;
  # };

  # services.telnet = {
  #   enable = true;
  #   # port = ;
  # };

  networking.iproute2.enable = true;

  # nixpkgs.config = {
  # };

  systemd.coredump.enable = true;

}
