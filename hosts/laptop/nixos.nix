{ config, lib, pkgs
, flakeInputs
, withSecrets 
, secrets
, ... }:
let 
  laptopAutoloaded = { pkgs, ... }@args: flakeInputs.haumea.lib.load {
   src = flakeInputs.nix-filter {
     root = ./.;
    include = [ 
      # "sops.nix"
      "sops/secrets.nix"
    ];
     # exclude = [
     #   "teto"
     #   "root"
     # ];
    };
    # loader = inputs: path: 
    #  inputs.super.defaultWith import;

    #  builtins.trace path path;
    inputs = args // {
      inputs = flakeInputs;
    };
    transformer = [
     flakeInputs.haumea.lib.transformers.liftDefault
     (flakeInputs.haumea.lib.transformers.hoistAttrs "_import" "import")
    ];
  };

  desktopAutoloaded = { pkgs, ... }@args: flakeInputs.haumea.lib.load {
   src = flakeInputs.nix-filter {
     root = ../desktop;
    include = [ 
      # "sops.nix"
      "sops/secrets.nix"
    ];
     # exclude = [
     #   "teto"
     #   "root"
     # ];
    };
    # loader = inputs: path: 
    #  inputs.super.defaultWith import;

    #  builtins.trace path path;
    inputs = args // {
      inputs = flakeInputs;
    };
    transformer = [
     flakeInputs.haumea.lib.transformers.liftDefault
     (flakeInputs.haumea.lib.transformers.hoistAttrs "_import" "import")
    ];
  };
in
{
  imports = [
    laptopAutoloaded
    desktopAutoloaded
    # ./services/openssh.nix
    # ./services/tlp.nix
    # ./services/thermald.nix
    # ./services/upower.nix

    ./sops.nix
    ./_hardware.nix
    # ../desktop/sops.nix
    # ../desktop/services/tailscale.nix

    ../config-all.nix
    ../../nixos/modules/luarocks-site.nix


    ../../nixos/profiles/wifi.nix
    ../../nixos/profiles/desktop.nix
    ../../nixos/profiles/podman.nix
    ../../nixos/profiles/sway.nix
    ../../nixos/profiles/docker-daemon.nix
    ../../nixos/profiles/greetd.nix
    ../../nixos/profiles/steam.nix
    ../../nixos/profiles/qemu.nix
    # ../../nixos/profiles/adb.nix
    # ../../nixos/profiles/nix-cache-sync.nix
    ../../nixos/profiles/kanata.nix
    ../../nixos/profiles/nix-daemon.nix
    ../../nixos/profiles/postgresql.nix
    # ../../nixos/profiles/home-assistant.nix 
    # usually inactive, just to test some stuff
    # ../../nixos/modules/libvirtd.nix

    # ./profiles/pixiecore.nix

   ] ++ lib.optionals withSecrets [
    ../../nixos/profiles/wireguard.nix
  ];

  # enables command on boot/suspend etc
  powerManagement.enable = false;

  # To control power levels via powerprofilesctl
  services.power-profiles-daemon.enable = true;

  # this is for gaming
  # just trying to make some steam warnings go away


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

  ### HWP
  # systemd.tmpfiles.rules = [
  #   "w /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference - - - - balance_power"
  # ];

  networking.hostName = "mcoudron"; # Define your hostname.

  # it apparently still is quite an important thing to have
  # boot.devSize = "5g";

  boot.kernelParams = [
   "acpi_backlight=legacy"
   # "acpi_osi=linux"

    # "acpi_backlight=vendor"
    # "i915.enable_psr=0"  # disables a power saving feature that can cause flickering
    # "ahci.mobile_lpm_policy=3"
    # "rtc_cmos.use_acpi_alarm=1"
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

  home-manager.users = 
   {
    root = {
     imports = [
      ../../hm/profiles/neovim.nix
      ../desktop/root/default.nix
      ../desktop/root/programs/ssh.nix
      ../../hm/profiles/nova/ssh-config.nix

     ];

    };

   teto = {
   # TODO it should load the whole folder
   imports = [
     # custom modules
     ../../hm/modules/package-sets.nix
     ./teto/default.nix
   ];
  };
 };


  # it is necessary to use dnssec though :(
  networking.resolvconf.dnsExtensionMechanism = false;
  networking.resolvconf.dnsSingleRequest = true; # juste pour test


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
    # to prevent the "failed to load regulatory.db" ?
    # see https://wireless.wiki.kernel.org/en/developers/regulatory
    udev.packages = [];

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

  environment.systemPackages = with pkgs; [
    # cups-pk-helper # to add printer through gnome control center
    pkgs.lm_sensors # to see CPU temperature (command 'sensors')
    pkgs.vlc # to see it in popcorn

    pkgs.nerdfonts
    ubuntu_font_family
    inconsolata # monospace
    noto-fonts-cjk # asiatic
    # (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    # nerdfonts
    # corefonts # microsoft fonts  UNFREE
    font-awesome_5
    source-code-pro
    dejavu_fonts
    # Adobe Source Han Sans
    source-han-sans #sourceHanSansPackages.japanese
    fira-code-symbols # for ligatures
    iosevka
  ];

  # service to update bios etc
  # managed to get this problem https://github.com/NixOS/nixpkgs/issues/47640
  services.fwupd.enable = true;
  services.gvfs.enable = true;

  # let's be fucking crazy
  # environment.enableDebugInfo = true;
  # } ++ lib.optionalAttrs (config.programs ? mininet) {

  networking.iproute2.enable = true;

  programs.gnome-disks = {
    enable = true;
  };

  system.stateVersion = "23.11";
  
  # services.logind = {
  #   # see https://bbs.archlinux.org/viewtopic.php?id=225977 for problems with LID
  #   # lidSwitch = "ignore";
  #   lidSwitch = "suspend";
  #   lidSwitchDocked = "suspend";
  #   lidSwitchExternalPower = "ignore";
  # };
}
