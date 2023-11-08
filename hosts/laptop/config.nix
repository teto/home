{ config, lib, pkgs, flakeInputs, secrets, ... }:
{
  imports = [
    ./sshd.nix
    ./sops.nix
    ./hardware.nix
    ../desktop/tailscale.nix

    ../config-all.nix
    ../../nixos/modules/luarocks-site.nix

    ../../nixos/profiles/distributedBuilds.nix
    ../../nixos/profiles/desktop.nix
    ../../nixos/profiles/podman.nix
    ../../nixos/profiles/sway.nix
    ../../nixos/profiles/docker-daemon.nix
    # ../../modules/xserver.nix
    # ./nixos/modules/redis.nix
    ../../nixos/profiles/steam.nix
    ../../nixos/profiles/qemu.nix
    # ../../nixos/profiles/adb.nix
    # ../../nixos/profiles/cron.nix
    # ../../nixos/profiles/kanata.nix
    ../../nixos/profiles/nix-daemon.nix
    ../../nixos/profiles/postgresql.nix
    ../../nixos/profiles/home-assistant.nix
    # usually inactive, just to test some stuff
    # ../../nixos/modules/libvirtd.nix

    # ./profiles/pixiecore.nix

  ];

  # TODO conditionnally enable it
  # networking.wireless.iwd.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enableCryptodisk = false;
  boot.loader.grub.enable = false;
  boot.loader.grub.device = "nodev";
  # boot.loader.grub.efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
  boot.loader.grub.efiSupport = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };
 
  # Enable swap on luks
  boot.initrd.luks.devices."luks-abd09d4b-3972-405a-b314-44821af95c0e".device = "/dev/disk/by-uuid/abd09d4b-3972-405a-b314-44821af95c0e";
  boot.initrd.luks.devices."luks-abd09d4b-3972-405a-b314-44821af95c0e".keyFile = "/crypto_keyfile.bin";
 
  # Enable the GNOME Desktop Environment.
#   services.xserver.displayManager.gdm.enable = true;
#   services.xserver.desktopManager.gnome.enable = true;


  networking.hostName = "mcoudron"; # Define your hostname.

  # it apparently still is quite an important thing to have
  # boot.devSize = "5g";

  boot.kernelParams = [
    "acpi_backlight=vendor"
    # "i915.enable_psr=0"  # disables a power saving feature that can cause flickering
  ];

  # boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelModules = [
    # "af_key" # for ipsec/vpn support
    "kvm"
    "kvm-intel" # for virtualisation
  ];

  boot.kernel.sysctl = {
    # to not provoke the kernel into crashing
    # "net.ipv4.tcp_timestamps" = 0;
    # "net.ipv4.tcp_allowed_congestion_control" = 0;
    # "net.ipv4.ipv4.ip_forward" = 1;
    # "net.ipv4.tcp_keepalive_time" = 60;
    # "net.core.rmem_max" = 4194304;
    # "net.core.wmem_max" = 1048576;
  };

  home-manager.users.root = {
   imports = [
    ../../hm/profiles/neovim.nix
    ../desktop/root/ssh-config.nix
   ];

  };

 home-manager.users.teto = {
   # TODO it should load the whole folder
   imports = [
     # custom modules
     ./home.nix
   ];
 };


  # it is necessary to use dnssec though :(
  networking.resolvconf.dnsExtensionMechanism = false;
  networking.resolvconf.dnsSingleRequest = true; # juste pour test

  # this is for gaming
  # just trying to make some steam warnings go away
  services.upower.enable = true;

  hardware = {
    # enableAllFirmware =true;
    enableRedistributableFirmware = true;
    sane.enable = true;
    # High quality BT calls
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      # hsphfpd.enable = false; # conflicts with pipewire
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
  # services.vault = {
  #   enable = true;
  #   dev = true;
  #   devRootTokenID = secrets.vault.rootTokenId;
  # };

  environment.systemPackages = [
    # cups-pk-helper # to add printer through gnome control center
    pkgs.lm_sensors # to see CPU temperature (command 'sensors')
  ];

  # service to update bios etc
  # managed to get this problem https://github.com/NixOS/nixpkgs/issues/47640
  services.fwupd.enable = true;
  services.gvfs.enable = true;

  programs.ccache.enable = false;

  # let's be fucking crazy
  # environment.enableDebugInfo = true;
  # } ++ lib.optionalAttrs (config.programs ? mininet) {

  networking.iproute2.enable = true;

  programs.gnome-disks = {
    enable = true;
  };

  system.stateVersion = "23.05";
  
  # services.logind = {
  #   # see https://bbs.archlinux.org/viewtopic.php?id=225977 for problems with LID
  #   # lidSwitch = "ignore";
  #   lidSwitch = "suspend";
  #   lidSwitchDocked = "suspend";
  #   lidSwitchExternalPower = "ignore";
  # };
}
