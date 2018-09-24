{ config, lib, pkgs,  ... }:
let
  secrets = import ./secrets.nix;
  # hopefully it can be generated as dirname <nixos-config>
  configDir = /home/teto/dotfiles/nixpkgs;
  userNixpkgs = /home/teto/nixpkgs;

  in
{
  imports = [
    /etc/nixos/hardware-configuration.nix

    ./common-desktop.nix
    # ./modules/libvirtd.nix
    ./modules/network-manager.nix
    ./modules/libvirtd.nix

    # ./extraTools.nix
    # ./modules/tor.nix
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

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_mptcp_with_netlink;

  # TODO we need nouveau 
  # boot.kernelModules = [
  #   "af_key" # for ipsec/vpn support
  #   "kvm" "kvm-intel" # for virtualisation
  # ];

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

  # my proxy
  # networking.proxy = rec {
  #   ftpProxy = "http://proxy.iiji.jp:8080/";
  #   httpProxy = ftpProxy;
  #   httpsProxy = ftpProxy;
  #   rsyncProxy = ftpProxy;
  #   noProxy="localhost,127.0.0.1";
  # };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  programs.ccache.enable = true;
  services.xserver.displayManager.slim = {
    # theme = 
    autoLogin = true;
    defaultUser = "teto";
  };
  
  nixpkgs.overlays = [
    (import ./overlays/kernels.nix) 
    (import ./overlays/haskell.nix) 
  ];

  nix = {

    buildMachines = [ 
      {
      hostName = "iij_mptcp";
      # todo move it to secrets
      sshUser = "teto";
      sshKey = "/home/teto/.ssh/iij_rsa";
      system = "x86_64-linux";
      maxJobs = 2;
      speedFactor = 2;
      supportedFeatures = [ "kvm" ];
      mandatoryFeatures = [ "perf" ];
      }
    ];
    distributedBuilds = true;


  };

  hardware.pulseaudio = {
    enable = true;

    systemWide = false;
    # daemon.config
    support32Bit = true;

    # Replace built in pulseaudio modules with enhanced bluetooth ones
    package = with pkgs; pulseaudioFull.overrideAttrs(oldAttrs: {
      postInstall = oldAttrs.postInstall + ''

        cp -a ${pulseaudio-modules-bt}/* $out/
      '';
    });
  };

  services.strongswan = {
    enable = true;
      # "/etc/ipsec.d/*.secrets" "/etc/ipsec.d"
    secrets = ["/etc/ipsec.d"];
  };

}
