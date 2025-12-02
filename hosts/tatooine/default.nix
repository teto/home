{
  lib,
  pkgs,
  flakeSelf,
  withSecrets,
  ...
}:
let
  haumea = flakeSelf.inputs.haumea;

  laptopAutoloaded =
    { pkgs, ... }@args:
    haumea.lib.load {
      src = flakeSelf.inputs.nix-filter {
        name = "laptopAutoloaded";
        root = ./.;
        include = [
          "boot.nix"
          "environment.nix"
          # UNCOMMENTING this will break everything since its content is not adapted
          # "home-manager/"
          "users/"
          "services/"
          "security/"
          "programs/"
          "hardware/"
          "home-manager/user/root/"

        ];

        exclude = [
          # "boot.nix"
          "generated.nix"
        ]
        ++ lib.optionals (!withSecrets) [
          "sops/secrets.nix"
        ];
      };

      inputs = args // {
        inputs = flakeSelf.inputs;
      };
      transformer = [
        haumea.lib.transformers.liftDefault
        (haumea.lib.transformers.hoistAttrs "_import" "import")
      ];
    };

  # tetosLib = pkgs.tetosLib;

  # nixosConfigurations
  # .nodes
  # builder_jedha = (tetosLib.nixosConfToBuilderAttr {} flakeSelf.nixosConfigurations.jedha);
  # builder_neotokyo = (tetosLib.nixosConfToBuilderAttr {} flakeSelf.nixosConfigurations.neotokyo);

  # b1 = pkgs.tetosLib.deployrsNodeToBuilderAttr flakeSelf.deploy.nodes.jedha;
  # {
  #   # using secrets.nix
  #   hostName = "jedha.local";
  #   system =  "x86_64-linux";
  # };

in
{
  imports = [
    laptopAutoloaded
    # should not ?!
    # desktopAutoloaded

    ../../tetos/disk-config.nix

    # removed 'cos it clashed with disk-config but these are not the same
    # ./generated.nix

    flakeSelf.inputs.disko.nixosModules.disko
    flakeSelf.nixosModules.nix-ld

    flakeSelf.nixosProfiles.hedgedoc
    flakeSelf.nixosProfiles.desktop
    flakeSelf.nixosProfiles.laptop
    # ../../nixos/profiles/docker-daemon.nix
    flakeSelf.nixosProfiles.podman
    # ../../nixos/profiles/podman.nix

    # ../../nixos/profiles/homepage-dashboard.nix
    # ../../nixos/profiles/steam.nix
    ../../nixos/profiles/kanata.nix
    # ../../nixos/profiles/postgresql.nix
    # ./services/tandoor.nix
    # ./services/linkwarden.nix

    # ../../nixos/profiles/home-assistant.nix
    # usually inactive, just to test some stuff
    # ../../nixos/modules/libvirtd.nix

  ];

  # services.tandoor-recipes.enable = true;
  # services.linkwarden = {
  #   enable = true;
  #   secretFiles.NEXTAUTH_SECRET = "TOTO";
  # };

  nix.buildMachines = [
    # builder_neotokyo

    # {
    #   # using secrets.nix
    #   hostName = "laptop.local";
    #   system =  "x86_64-linux";
    # }
  ];

  nixpkgs.overlays = lib.optionals withSecrets [

  ];

  # boot.blacklistedKernelModules = [ "nouveau" ];

  # enables command on boot/suspend etc

  security.polkit.enable = true;

  # https://github.com/rycee/home-manager/pull/829
  # https://discourse.nixos.org/t/sway-nixos-home-manager-conflict/20760/10

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

  # Enable swap on luks
  # boot.initrd.luks.devices."luks-abd09d4b-3972-405a-b314-44821af95c0e".keyFile = "/crypto_keyfile.bin";

  ### HWP

  home-manager.users = {
    # root = {
    #   imports = [
    #     ./home-manager/users/root/default.nix
    #   ];
    # };

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
  networking.domain = "tatooine.local";

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    sane.enable = true;
    # High quality BT calls
    bluetooth = {
      enable = true;
      powerOnBoot = false;
      # hsphfpd.enable = false; # conflicts with pipewire
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
    udev.packages = [
      pkgs.yubikey-personalization
    ];

    # just locate
    locate.enable = true;
    # dbus.packages = [ ];
  };

  # experimental
  # niriswitch on hm level
  programs.niri.enable = true;

  services.displayManager.logToFile = true;

  # services.displayManager.ly.enable = true;

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

  programs.gnome-disks = {
    enable = true;
  };

  # smartcard service for yubikey
  # can conflict with gpg-agent depending on config
  services.pcscd.enable = true;
  services.yubikey-agent.enable = true;

  system.stateVersion = "25.05";

  services.journald.extraConfig = ''
    # alternatively one can run journalctl --vacuum-time=2d
    SystemMaxUse=2G
  '';

  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # to remove "TSC_DEADLINE disabled due to Errata;
  # please update microcode to version: 0x22"
  # hardware.cpu.intel.updateMicrocode = true;

  # services.logind = {
  #   # see https://bbs.archlinux.org/viewtopic.php?id=225977 for problems with LID
  #   # lidSwitch = "ignore";
  #   lidSwitch = "suspend";
  #   lidSwitchDocked = "suspend";
  #   lidSwitchExternalPower = "ignore";
  # };
}
