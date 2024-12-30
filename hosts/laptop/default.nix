{
  config,
  lib,
  pkgs,
  flakeInputs,
  flakeSelf,
  withSecrets,
  secrets,
  ...
}:
let
  laptopAutoloaded =
    { pkgs, ... }@args:
    flakeSelf.inputs.haumea.lib.load {
      src = flakeSelf.inputs.nix-filter {
        name = "laptopAutoloaded";
        root = ./.;
        include = [
          "boot.nix"
          "environment.nix"
          # UNCOMMENTING this will break everything since its content is not adapted
          # "home-manager/"
          # "home-manager/"
          "users/"
          "services/"
          "security/"
          "programs/"
          "hardware/"

        ];

        exclude =
          [
            # "boot.nix"
            "generated.nix"
          ]
          ++ lib.optionals (!withSecrets) [
            "sops/secrets.nix"
            "services/openssh.nix"
          ];
      };

      inputs = args // {
        inputs = flakeSelf.inputs;
      };
      transformer = [
        flakeInputs.haumea.lib.transformers.liftDefault
        (flakeInputs.haumea.lib.transformers.hoistAttrs "_import" "import")
      ];
    };

  desktopAutoloaded =
    { pkgs, ... }@args:
    flakeSelf.inputs.haumea.lib.load {
      src = flakeSelf.inputs.nix-filter {
        root = ../desktop;
        include = [
          # TODO just include directly
          # "sops.nix"
          "sops/secrets.nix"
        ];
        # exclude = [
        #   "teto"
        #   "root"
        # ];
      };

      inputs = args // {
        inputs = flakeSelf.inputs;
      };
      transformer = [
        flakeInputs.haumea.lib.transformers.liftDefault
        (flakeInputs.haumea.lib.transformers.hoistAttrs "_import" "import")
      ];
    };
in
{
  imports =
    [
      laptopAutoloaded
      # should not ?!
      desktopAutoloaded

      ./sops.nix
      ./generated.nix

      # ../../nixos/modules/luarocks-site.nix

      flakeSelf.nixosModules.sudo
      flakeSelf.nixosModules.universal
      flakeSelf.nixosModules.nix-daemon

      # TODO this triggers the error on boot I think
      ../../nixos/profiles/desktop.nix

      ../../nixos/profiles/docker-daemon.nix
      ../../nixos/profiles/greetd.nix
      ../../nixos/profiles/podman.nix
      ../../nixos/profiles/qemu.nix
      ../../nixos/profiles/steam.nix
      ../../nixos/profiles/sway.nix
      ../../nixos/profiles/wifi.nix
      # ../../nixos/profiles/adb.nix
      ../../nixos/profiles/kanata.nix
      ../../nixos/profiles/postgresql.nix
      # ../../nixos/profiles/home-assistant.nix
      # usually inactive, just to test some stuff
      # ../../nixos/modules/libvirtd.nix

    ]
    ++ lib.optionals withSecrets [
      flakeSelf.nixosModules.novaModule
    ];

  boot.blacklistedKernelModules = [ "nouveau" ];

  # enables command on boot/suspend etc
  # powerManagement.enable = true;
  # powerManagement.cpuFreqGovernor = "powersave";

  security.polkit.enable = true;

  # To control power levels via powerprofilesctl
  # services.power-profiles-daemon.enable = true;

  # this is for gaming
  # just trying to make some steam warnings go away

  # TODO conditionnally enable it
  # networking.wireless.iwd.enable = true;
  boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/EFI";
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub.enableCryptodisk = false;
  # boot.loader.grub.enable = false;
  # boot.loader.grub.device = "nodev";
  # boot.loader.grub.efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
  # boot.loader.grub.efiSupport = true;

  # Setup keyfile
  # boot.initrd.secrets = {
  #   # for systemd-crypt or luks ?
  #   "/crypto_keyfile.bin" = null;
  # };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable swap on luks
  # boot.initrd.luks.devices."luks-abd09d4b-3972-405a-b314-44821af95c0e".device = "/dev/disk/by-uuid/abd09d4b-3972-405a-b314-44821af95c0e";
  # boot.initrd.luks.devices."luks-abd09d4b-3972-405a-b314-44821af95c0e".keyFile = "/crypto_keyfile.bin";

  ### HWP

  home-manager.users = {
    root = {
      imports = [
        # ../desktop/root/programs/ssh.nix
        ./home-manager/users/root/default.nix

        # flakeSelf.homeModules.neovim
        # ] ++ lib.optionals withSecrets [
        #   # ../../hm/profiles/nova/ssh-config.nix
        #     flakeSelf.homeModules.nova
      ];
    };

    teto = {
      # TODO it should load the whole folder
      imports = [
        # custom modules
        ./home-manager/users/teto/default.nix
      ];
    };
  };

  # it is necessary to use dnssec though :(
  networking.resolvconf.dnsExtensionMechanism = false;
  networking.resolvconf.dnsSingleRequest = true; # juste pour test
  networking.hostName = "mcoudron"; # Define your hostname.

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
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    pulseaudio = {
      enable = false;
      systemWide = false;

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
    udev.packages = [ ];

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

  # environment.
  # service to update bios etc
  # managed to get this problem https://github.com/NixOS/nixpkgs/issues/47640
  services.fwupd.enable = true;
  services.gvfs.enable = true;

  # let's be fucking crazy
  # environment.enableDebugInfo = true;
  # } ++ lib.optionalAttrs (config.programs ? mininet) {

  networking.iproute2.enable = true;

  swapDevices = [
    {
      device = "/fucking_swap";
      size = 16000; # in MB
      # randomEncryption.enable = true;
      # options = [ "nofail" ];
      # priority = 5;
    }
  ];

  # default is 60. Range is 0-200. Lower number says use RAM rather than swap.
  # I considered it, didn't try it out yet
  zramSwap = {
    enable = true;
    priority = 10; # higher than HDD swap
  };

  programs.gnome-disks = {
    enable = true;
  };

  system.stateVersion = "24.11";

  # services.logind = {
  #   # see https://bbs.archlinux.org/viewtopic.php?id=225977 for problems with LID
  #   # lidSwitch = "ignore";
  #   lidSwitch = "suspend";
  #   lidSwitchDocked = "suspend";
  #   lidSwitchExternalPower = "ignore";
  # };
}
