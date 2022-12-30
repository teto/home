{ config, lib, pkgs, ... }:
let
  secrets = import ./secrets.nix;
  # hopefully it can be generated as dirname <nixos-config>
  configDir = /home/teto/dotfiles/nigpkgs;
  userNixpkgs = /home/teto/nixpkgs;

in
{
  imports = [
    ./hardware-macbook.nix
    ./desktop.nix
    ./modules/docker-daemon.nix
    # ./modules/libvirtd.nix

    # just for testing
    # ./modules/nextcloud.nix
    # ./modules/tor.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true; # allows to run $ efi...

    # just to generate the entry used by ubuntu's grub
    # boot.loader.grub.enable = true;
    # boot.loader.grub.version = 2;
    # install to none, we just need the generated config
    # for ubuntu grub to discover
    grub.device = "/dev/sda";
  };

  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_5_6.override {
    structuredExtraConfig = with lib.kernel; {
      MPTCP = yes;
      MPTCP_IPV6 = yes;
    };
  });

  # programs.mininet.enable = true;

  # TODO we need nouveau
  # boot.kernelModules = [
  #   "af_key" # for ipsec/vpn support
  #   "kvm" "kvm-intel" # for virtualisation
  # ];

  networking.hostName = "jedha"; # Define your hostname.

  # networking.firewall.allowedUDPPorts = [ ];
  # creates problem with buffalo check if it blocks requests or what
  # it is necessary to use dnssec though :(
  networking.resolvconf.dnsExtensionMechanism = false;

  # this is for gaming
  hardware.opengl.driSupport32Bit = true;

  # programs.seahorse.enable = true; # UI to manage keyrings

  # List services that you want to enable:
  services = {
    gnome = {
      gnome-keyring.enable = true;
      at-spi2-core.enable = true; # for keyring it seems

      # to be able to see the trash in nautilus
      # gvfs.enable = true;
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

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  programs.ccache.enable = true;

  nixpkgs = {
    overlays = [
    ];

    config = {
      android_sdk.accept_license = true;
      permittedInsecurePackages = [ ];
      # allowBroken = true;
      allowUnfree = true; # for nvidia drivers
    };
  };

  nix = {
    # 0 = default/highest vs 7 lowest
    # 0 = max (default) vs 19 lowest
    # daemonNiceLevel = 2;
    distributedBuilds = true;
  };
}
