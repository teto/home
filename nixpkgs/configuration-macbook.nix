{ config, lib, pkgs,  ... }:
let
  secrets = import ./secrets.nix;
  # hopefully it can be generated as dirname <nixos-config>
  configDir = /home/teto/dotfiles/nixpkgs;
  userNixpkgs = /home/teto/nixpkgs;

  in
{
  imports = [
    ./hardware-macbook.nix
    ./modules/desktop.nix
    ./modules/network-manager.nix
    # ./modules/libvirtd.nix
    # ./modules/vpn.nix
    # ./modules/distributedBuilds.nix

    # just for testing
    # ./modules/nextcloud.nix
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

  # boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_mptcp_with_netlink;
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_5_6;

  # programs.mininet.enable = true;

  # TODO we need nouveau
  # boot.kernelModules = [
  #   "af_key" # for ipsec/vpn support
  #   "kvm" "kvm-intel" # for virtualisation
  # ];

  networking.hostName = "jedha"; # Define your hostname.

  # TODO add the chromecast
  # networking.firewall.allowedUDPPorts = [ ];
  # creates problem with buffalo check if it blocks requests or what
  # it is necessary to use dnssec though :(
  networking.resolvconf.dnsExtensionMechanism = false;

  # this is for gaming
  hardware.opengl.driSupport32Bit = true;

  # programs.seahorse.enable = true; # UI to manage keyrings

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
      # (import ./overlays/kernels.nix)
      # (import ./overlays/haskell.nix)
      # to get xdg_utils
      # (import ./overlays/i3.nix)
    ];

    config = {
      android_sdk.accept_license = true;

      permittedInsecurePackages = [ ];

      # allowBroken = true;
      allowUnfree = true;  # for nvidia drivers
    };
  };

  nix = {
    # might be useful to fetch from private repositories even in sandboxed mode ?!
    # fetchGit is run as user so no
    # envVars = {
    # };
    # extraConfig = ''
    # '';

    # 0 = default/highest vs 7 lowest
    # daemonIONiceLevel = 3;
    # 0 = max (default) vs 19 lowest
    # daemonNiceLevel = 2;
    distributedBuilds = true;
  };

  hardware.pulseaudio = {
    enable = true;

    systemWide = false;
    # daemon.config
    support32Bit = true;

    extraModules = [ pkgs.pulseaudio-modules-bt ];

    package = pkgs.pulseaudioFull;
    # Replace built in pulseaudio modules with enhanced bluetooth ones
    # package = with pkgs; pulseaudioFull.overrideAttrs(oldAttrs: {
    #   postInstall = oldAttrs.postInstall + ''

    #     cp -a ${pulseaudio-modules-bt}/* $out/
    #   '';
    # });
  };

  services.greenclip.enable = true;

  # for android development
  programs.adb.enable = false;
}
