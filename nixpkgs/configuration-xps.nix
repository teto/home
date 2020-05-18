{ config, lib, pkgs,  ... }:
let
  #secrets = import ./secrets.nix;
  # hopefully it can be generated as dirname <nixos-config>

  in
{
  imports = [
    # todo renommer en workstation
    # ./hardware-dell.nix
    ./hardware-xps.nix

    ./modules/config-all.nix
    ./modules/desktop.nix
    ./modules/docker-daemon.nix
    ./profiles/nova-dev.nix


    ./modules/libvirtd.nix
    ./modules/distributedBuilds.nix

    # ./modules/mptcp.nix
    # ./modules/vpn.nix

    # ./modules/tor.nix

  ] ;

  # TODO conditionnally enable it
  # networking.proxy.default
  # networking.wireless.iwd.enable = true;

  # it apparently still is quite an important thing to have
  boot.devSize = "5g";

  boot.loader ={
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true; # allows to run $ efi...

  # just to generate the entry used by ubuntu's grub
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # install to none, we just need the generated config
  # for ubuntu grub to discover
    # grub.device = "/dev/sda";
  };

  boot.kernelParams = [ " console=ttyS0" "acpi_backlight=vendor" "i915.enable_psr=0" ];

  # TODO use the mptcp one ?
  # boot.kernelPackages = pkgs.linuxPackages;
  # boot.kernelPackages = pkgs.linuxPackages_mptcp;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_4_14;

  # boot.extraModprobeConfig = ''
    # options iwlwifi bt_coex_active=0
    # options iwlwifi 11n_disable=1
    # options iwlwifi swcrypto=1
  # '';

  # TODO we need nouveau
  boot.kernelModules = [
    "af_key" # for ipsec/vpn support
    "kvm" "kvm-intel" # for virtualisation
  ];
  # boot.extraModulePackages = [];
  # boot.blacklistedKernelModules = [];
  # boot.hardwareScan = true;

  boot.kernel.sysctl = {
    # to not provoke the kernel into crashing
    # "net.ipv4.tcp_timestamps" = 0;
    # "net.ipv4.tcp_allowed_congestion_control" = 0;
    # "net.ipv4.ipv4.ip_forward" = 1;
    # "net.ipv4.tcp_keepalive_time" = 60;
    # "net.core.rmem_max" = 4194304;
    # "net.core.wmem_max" = 1048576;
  };

  networking.hostName = "jedha"; # Define your hostname.

  # TODO add the chromecast
  networking.firewall.allowedUDPPorts = [ ];
  # creates problem with buffalo check if it blocks requests or what
  # it is necessary to use dnssec though :(
  networking.resolvconf.dnsExtensionMechanism = false;
  networking.resolvconf.dnsSingleRequest = true; # juste pour test
  # not merged yet
  # networking.wireless.iwd.enable = true;

  # networking.networkmanager.wifi.backend = "iwd";

  # this is for gaming
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio = {
    enable = true;
    systemWide = false;
  #  support32Bit = true;
  #  # daemon.config = ''
  #  #   load-module module-switch-on-connect
  #  #   '';

    # adds out-of-tree support for AAC, APTX, APTX-HD and LDAC.
    # SBC / AAC
    extraModules = [ pkgs.pulseaudio-modules-bt ];

    # extraClientConf =
    # only this one has bluetooth
    package = pkgs.pulseaudioFull;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;

    # as per https://nixos.wiki/wiki/Bluetooth recommendation
    # config = {
    #   General = {
    #     Enable="Source,Sink,Media,Socket";
    #   };
    # };
  };

  # TODO move to laptop
  # see https://github.com/NixOS/nixpkgs/issues/57053
  hardware.firmware = with pkgs; [ wireless-regdb ];
#  boot.extraModprobeConfig = ''
#    options cfg80211 ieee80211_regdom="GB"
#  '';

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

    # central regulatory domain agent (CRDA) to allow exchange between kernel and userspace
    #
    # to prevent the "failed to load regulatory.db" ?
    # see https://wireless.wiki.kernel.org/en/developers/regulatory
    udev.packages = [ pkgs.crda ];

    # just locate
    locate.enable = true;

    # dbus.packages = [ ];
  };

  environment.systemPackages = with pkgs;
    # strongswan # to get ipsec in path
    # cups-pk-helper # to add printer through gnome control center
    [
      # pkgs.brightnessctl
      ]
  ;

  # need to be video
  # hardware.acpilight.enable = true;

  # service to update bios etc
  # managed to get this problem https://github.com/NixOS/nixpkgs/issues/47640
  services.fwupd.enable = true;

  programs.ccache.enable = true;


  # use with nix-locate to find a file across packages
  # DOES NOT EXIST YET :'(
  # programs.nix-index.enable = true;

  # when set to false, /etc/passwd and /etc/group will be congruent to your NixOS configuration
  # users.mutableUsers = false;

  # let's be fucking crazy
  # environment.enableDebugInfo = true;
# } ++ lib.optionalAttrs (config.programs ? mininet) {

  # programs.mininet.enable = true;

  # virtualisation.virtualbox = {
  #   host.enable = true;
  #   host.enableExtensionPack = true;
  #   host.addNetworkInterface = true; # adds vboxnet0
  #   # Enable hardened VirtualBox, which ensures that only the binaries in the system path get access to the devices exposed by the kernel modules instead of all users in the vboxusers group.
  #    host.enableHardening = true;
  #    host.headless = false;
  # };

  # nixpkgs.overlays = [
  #   (import ./overlays/kernels.nix)
  #   (import ./overlays/haskell.nix)
  # ];


  services.hoogle = {
    enable = true;
    # port

    packages = hs: with hs; [
      http-api-data
      servant
      servant-server
    ];

  };

  networking.iproute2.enable = true;

  nix = {
    package = pkgs.nixFlakes;

    # sshServe = {
    #   enable = true;
    #   protocol = "ssh";
    #   # keys = [ secrets.gitolitePublicKey ];
    # };

    # added to nix.conf
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    distributedBuilds = false;
  };

  # services.logind = {
  #   # see https://bbs.archlinux.org/viewtopic.php?id=225977 for problems with LID
  #   # lidSwitch = "ignore";
  #   lidSwitch = "suspend";
  #   lidSwitchDocked = "suspend";
  #   lidSwitchExternalPower = "ignore";
  # };

}
