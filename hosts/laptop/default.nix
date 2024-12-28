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
    args:
    flakeSelf.inputs.haumea.lib.load {
      src = lib.fileset.toSource {
          root = ./.;
          # lib.fileset.traceVal 
          fileset = (flakeSelf.inputs.globset.lib.globs ./. ([
            "**/*.nix"
            "*.nix"
            "!generated.nix"
            # TODO
            "home-manager/users/teto/default.nix"
          ]
          ++ lib.optionals (!withSecrets) [
            # "sops/secrets.nix"
            "services/openssh.nix"
          ]));

        };

      # src = flakeSelf.inputs.nix-filter {
      #   name = "laptopAutoloaded";
      #   root = ./.;
      #   include = [
      #     "boot.nix"
      #     "environment.nix"
      #     # UNCOMMENTING this will break everything since its content is not adapted
      #     # "home-manager/"
      #     "home-manager/"
      #     "users/"
      #     "services/"
      #     "security/"
      #     "programs/"
      #     "hardware/"
      #   ];
      #
      #   exclude =
      #     [
      #       # "boot.nix"
      #       "generated.nix"
      #       "home-manager/users/teto/"
      #     ]
      #     ++ lib.optionals (!withSecrets) [
      #       "sops/secrets.nix"
      #       "services/openssh.nix"
      #     ];
      # };

      inputs = (builtins.removeAttrs args ["pkgs"] ) // {
        inputs = flakeSelf.inputs;
      };
      transformer = [
        flakeInputs.haumea.lib.transformers.liftDefault
        (flakeInputs.haumea.lib.transformers.hoistAttrs "_imports" "imports")
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

  # boot.blacklistedKernelModules = [ "nouveau" ];

  # enables command on suspend etc
  # powerManagement.enable = true;
  # powerManagement.cpuFreqGovernor = "powersave";

  # security.polkit.enable = true;

  # To control power levels via powerprofilesctl
  # services.power-profiles-daemon.enable = true;

  # this is for gaming
  # just trying to make some steam warnings go away

  # TODO conditionnally enable it
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;


  # Setup keyfile
  # boot.initrd.secrets = {
  #   # for systemd-crypt or luks ?
  #   "/crypto_keyfile.bin" = null;
  # };

  # Load nvidia driver for Xorg and Wayland
  # services.xserver.videoDrivers = [ "nvidia" ];

  # Enable swap on luks
  # boot.initrd.luks.devices."luks-abd09d4b-3972-405a-b314-44821af95c0e".device = "/dev/disk/by-uuid/abd09d4b-3972-405a-b314-44821af95c0e";
  # boot.initrd.luks.devices."luks-abd09d4b-3972-405a-b314-44821af95c0e".keyFile = "/crypto_keyfile.bin";

  ### HWP

  # home-manager.users = {
  #   root = {
  #     imports = [
  #       # ../desktop/root/programs/ssh.nix
  #       ./home-manager/users/root/default.nix
  #
  #       # flakeSelf.homeModules.neovim
  #       # ] ++ lib.optionals withSecrets [
  #       #   # ../../hm/profiles/nova/ssh-config.nix
  #       #     flakeSelf.homeModules.nova
  #     ];
  #   };
  #
  #   teto = {
  #     # TODO it should load the whole folder
  #     imports = [
  #       # custom modules
  #       ./home-manager/users/teto/default.nix
  #     ];
  #   };
  # };

  # it is necessary to use dnssec though :(
  # networking.resolvconf.dnsExtensionMechanism = false;
  # networking.resolvconf.dnsSingleRequest = true; # juste pour test
  # networking.hostName = "mcoudron"; # Define your hostname.
  # networking.iproute2.enable = true;
  # networking.wireless.iwd.enable = true;

  # moved to hardware/default.nix
  # hardware = {
  #   # enableAllFirmware =true;
  #   enableRedistributableFirmware = true;
  #   sane.enable = true;
  #   # High quality BT calls
  #   bluetooth = {
  #     enable = true;
  #     powerOnBoot = true;
  #     # hsphfpd.enable = false; # conflicts with pipewire
  #   };
  #   graphics = {
  #     enable = true;
  #     enable32Bit = true;
  #   };
  #   pulseaudio = {
  #     enable = false;
  #     systemWide = false;
  #
  #     # extraClientConf =
  #     # only this one has bluetooth
  #     package = pkgs.pulseaudioFull;
  #   };
  # };

  # TODO move to laptop
  # see https://github.com/NixOS/nixpkgs/issues/57053
  #  boot.extraModprobeConfig = ''
  #    options cfg80211 ieee80211_regdom="GB"
  #  '';


  # for tests
  # services.vault = {
  #   enable = true;
  #   dev = true;
  #   devRootTokenID = secrets.vault.rootTokenId;
  # };

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

  system.stateVersion = "24.11";

  # services.logind = {
  #   # see https://bbs.archlinux.org/viewtopic.php?id=225977 for problems with LID
  #   # lidSwitch = "ignore";
  #   lidSwitch = "suspend";
  #   lidSwitchDocked = "suspend";
  #   lidSwitchExternalPower = "ignore";
  # };
}
