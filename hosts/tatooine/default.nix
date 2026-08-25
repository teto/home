{
  lib,
  pkgs,
  flakeSelf,
  # withSecrets,
  ...
}:
let
  haumea = flakeSelf.inputs.haumea;

  laptopAutoloaded =
    { pkgs, ... }@args:
    haumea.lib.load {
      src = lib.fileset.toSource {
        root = ./.;
        fileset = lib.fileset.unions [
          ./boot.nix
          ./environment.nix
          ./home-manager/users/root
          ./home-manager/users/teto/default.nix
          ./networking
          ./nix.nix
          ./programs
          ./sops.nix
          ./systemd.nix
          ./services
          ./security
          ./tetos.nix
          ./users
        ];
      };

      inputs = args // {
        inputs = flakeSelf.inputs;
      };
      transformer = [
        haumea.lib.transformers.liftDefault
        (haumea.lib.transformers.hoistLists "_imports" "imports")
      ];
    };

in
{
  imports = [
    laptopAutoloaded
    flakeSelf.inputs.disko.nixosModules.disko
    flakeSelf.inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen5

    flakeSelf.nixosProfiles.disko-desktop
    flakeSelf.nixosProfiles.networkmanager
    flakeSelf.nixosProfiles.wyoming

    # removed 'cos it clashed with disk-config but these are not the same
    # ./generated.nix

    # useful for uv
    flakeSelf.nixosProfiles.nix-ld

    # flakeSelf.nixosProfiles.hedgedoc
    # flakeSelf.nixosProfiles.rmfakecloud # useless without hacking remarkable
    flakeSelf.nixosProfiles.desktop
    flakeSelf.nixosProfiles.laptop
    flakeSelf.nixosProfiles.podman
    flakeSelf.nixosProfiles.experimental
    flakeSelf.nixosProfiles.steam

    flakeSelf.nixosProfiles.kanata
    # ./services/linkwarden.nix

    # ./networking/wireguard.nix
    # flakeSelf.nixosProfiles.home-assistant
    # usually inactive, just to test some stuff
  ];

  environment.systemPackages = [
  ];

  # services.vaultwarden = {
  #   enable = true;
  # };

  # services.pipewire.wireplumber.configPackages = [
  # pkgs.hello
  # (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-bluez.conf" ''
  #   monitor.bluez.properties = {
  #     bluez5.roles = [ a2dp_sink a2dp_source bap_sink bap_source hsp_hs hsp_ag hfp_hf hfp_ag ]
  #     bluez5.codecs = [ sbc sbc_xq aac ]
  #     bluez5.enable-sbc-xq = true
  #     bluez5.hfphsp-backend = "native"
  #   }
  # '')
  # ];

  # enables command on boot/suspend etc
  security.polkit.enable = true;

  boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/EFI";
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub.enableCryptodisk = false;

  # Setup keyfile
  # boot.initrd.secrets = {
  #   # for systemd-crypt or luks ?
  #   "/crypto_keyfile.bin" = null;
  # };
  ### HWP

  home-manager.users = {
    teto = {
      # TODO it should load the whole folder
      imports = [
        # custom modules
        ./home-manager/users/teto/default.nix
      ];
    };
  };

  # it is necessary to use dnssec though :(
  # hostId
  networking.hostName = "tatooine"; # Define your hostname.
  networking.domain = ".local";

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    sane.enable = true;

    # cant be enabled with pipewire
    # pulseaudio = {
    #   enable = true;
    #   package = pkgs.pulseaudioFull;
    # };

    # High quality BT calls
    # https://nixos.wiki/wiki/Bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = false;
      # package =
      # written to /etc/bluetooth/main.conf
      settings = {

        General = {
          Name = "toto";

          # Shows battery charge of connected devices on supported
          # Bluetooth adapters. Defaults to 'false'.
          Experimental = true;

          # to work with a2dp profile (seems outdated)
          # unknown key
          # Enable = "Source,Sink,Media,Socket";
        };
        Policy = {
          # Enable all controllers when they are found. This includes
          # adapters present on start as well as adapters that are plugged
          # in later on. Defaults to 'true'.
          AutoEnable = true;
        };
      };
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  # TODO move to laptop
  # see https://github.com/NixOS/nixpkgs/issues/57053
  #  boot.extraModprobeConfig = ''
  #    options cfg80211 ieee80211_regdom="GB"
  #  '';

  # List services that you want to enable:
  services = {
    gnome = {
      # gnome-keyring.enable = true;
      at-spi2-core.enable = true; # for keyring it seems
    };

    # central regulatory domain agent (CRDA) to allow exchange between kernel and userspace
    # to prevent the "failed to load regulatory.db" ?
    # see https://wireless.wiki.kernel.org/en/developers/regulatory
    udev.packages = [
      pkgs.yubikey-personalization
      pkgs.brightnessctl
    ];

    # just locate
    locate.enable = true;
    # dbus.packages = [ ];
  };

  # environment.
  # service to update bios etc
  # managed to get this problem https://github.com/NixOS/nixpkgs/issues/47640
  services.fwupd.enable = true;
  services.gvfs.enable = true;

  networking.iproute2.enable = true;

  swapDevices = [
    {
      device = "/fucking_swap";
      size = 32000; # in MB
      # randomEncryption.enable = true;
      # options = [ "nofail" ];
      # priority = 5;
      # options = ["discard"];
    }
  ];

  # default is 60. Range is 0-200. Lower number says use RAM rather than swap.
  # I considered it, didn't try it out yet
  # zramSwap = {
  #   enable = false;
  #   priority = 10; # higher than HDD swap
  # };

  services.flatpak.enable = true;

  # smartcard service for yubikey
  # can conflict with gpg-agent depending on config
  system.stateVersion = "26.05";

  services.journald.extraConfig = ''
    # alternatively one can run journalctl --vacuum-time=2d
    SystemMaxUse=2G
  '';

  # to remove "TSC_DEADLINE disabled due to Errata;
  # please update microcode to version: 0x22"
  # hardware.cpu.intel.updateMicrocode = true;
}
