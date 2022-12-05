{ config, lib, pkgs,  ... }:
let
  secrets = import ../../nixpkgs/secrets.nix;
in
{
  imports = [
    ../config-all.nix
    ../desktop.nix
    ../../modules/sway.nix
    ../../modules/syncthing.nix
    # ./modules/docker-daemon.nix

    # ./modules/hoogle.nix
    # ./profiles/pixiecore.nix
    # ./modules/mptcp.nix

    # may provoke some issues like switch hanging
    # ./modules/kubernetes.nix
    # ./modules/tor.nix
  ] ;

  # TODO conditionnally enable it
  # networking.wireless.iwd.enable = true;

  # it apparently still is quite an important thing to have
  # boot.devSize = "5g";

  boot.kernelParams = [ 
	# "acpi_backlight=vendor"
	# "i915.enable_psr=0"  # disables a power saving feature that can cause flickering
	];

  # TODO use the mptcp one ?
  # boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # TODO we need nouveau
  boot.kernelModules = [
    # "af_key" # for ipsec/vpn support
    "kvm"
    "kvm-intel" # for virtualisation
  ];

  # boot.extraModulePackages = [];
  # boot.blacklistedKernelModules = [];

  boot.kernel.sysctl = {
    # to not provoke the kernel into crashing
    # "net.ipv4.tcp_timestamps" = 0;
    # "net.ipv4.tcp_allowed_congestion_control" = 0;
    # "net.ipv4.ipv4.ip_forward" = 1;
    # "net.ipv4.tcp_keepalive_time" = 60;
    # "net.core.rmem_max" = 4194304;
    # "net.core.wmem_max" = 1048576;
  };


  # it is necessary to use dnssec though :(
  networking.resolvconf.dnsExtensionMechanism = false;
  networking.resolvconf.dnsSingleRequest = true; # juste pour test

  # this is for gaming
  # just trying to make some steam warnings go away
  services.upower.enable = true;

  hardware= {
    # enableAllFirmware =true;
    enableRedistributableFirmware =true;
    sane.enable = true;
    # High quality BT calls
    bluetooth = {
      enable = true;
      powerOnBoot = false;
      hsphfpd.enable = true;
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    pulseaudio = {
      enable = false;
      systemWide = false;

      # adds out-of-tree support for AAC, APTX, APTX-HD and LDAC.
      # SBC / AAC
      extraModules = [
        pkgs.pulseaudio-modules-bt
      ];

      # extraClientConf =
      # only this one has bluetooth
      package = pkgs.pulseaudioFull;

    };


  };

  # TODO move to laptop
  # see https://github.com/NixOS/nixpkgs/issues/57053
#  boot.extraModprobeConfig = ''
#    options cfg80211 ieee80211_regdom="GB"
#  '';

  security.sudo.extraConfig = ''
    Defaults        timestamp_timeout=60
  '';

  # programs.seahorse.enable = true; # UI to manage keyrings

  # List services that you want to enable:
  services = {
    gnome = {
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

  # for tests
  services.vault = {
	enable = true;
	dev = true;
	devRootTokenID = secrets.vault.rootTokenId;
  };

  environment.systemPackages = [
    # cups-pk-helper # to add printer through gnome control center
      pkgs.lm_sensors # to see CPU temperature (command 'sensors')
    ]
  ;

  # service to update bios etc
  # managed to get this problem https://github.com/NixOS/nixpkgs/issues/47640
  services.fwupd.enable = true;
  services.gvfs.enable = true;

  programs.ccache.enable = false;

  # when set to false, /etc/passwd and /etc/group will be congruent to your NixOS configuration
  # users.mutableUsers = false;

  # let's be fucking crazy
  # environment.enableDebugInfo = true;
# } ++ lib.optionalAttrs (config.programs ? mininet) {

  networking.iproute2.enable = true;

  # services.xserver.videoDrivers = [ "nvidia" ];

  programs.gnome-disks = {
    enable = true;
  };

  nix = {
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
