/*
  the router is an APU4D4, i.e., x86-based system
  https://teklager.se/en/products/routers/apu4d4-open-source-router

  Links of interest:
  - https://dataswamp.org/~solene/2022-08-03-nixos-with-live-usb-router.html
  - https://skogsbrus.xyz/blog/2022/06/12/router/
  - https://francis.begyn.be/blog/nixos-home-router
  - https://www.jjpdev.com/posts/home-router-nixos/

  When booting, hit tab to edit the boot entry.
  Normally NixOS does not output to serial in the boot process, so we need to enable is by appending console=ttyS0,115200 to the boot entry. All characters appear twice, so just make sure you type it correctyl ;) . ctrl+l can be used to refresh the screen.
   After installing, you want to make sure that the PCEngine APU entry from the NixOS hardware repo is present, as it enables the console port.
*/
{
  # config,
  # lib,
  pkgs,
  secrets,
  flakeSelf,
  ...
}:
{
  # pcengines/apu/
  imports = [
    flakeSelf.inputs.nixos-hardware.nixosModules.pcengines-apu
    flakeSelf.nixosModules.default-hm
    flakeSelf.inputs.disko.nixosModules.disko

    # ./iwd.nix # unused it seems
    ./disko-config.nix
    ./hardware.nix
    ./networking.nix
    ./systemd/default.nix
    ./services/openssh.nix
    ./services/home-assistant.nix
    ./services/music-assistant.nix
    ./services/zigbee2mqtt.nix

    # services.resolved.settings.Resolve.MulticastDNS = true;
    ./services/resolved.nix
    # ./services/mqtt.nix

    # TODO replace with systemd mdns
    # flakeSelf.nixosProfiles.avahi
    flakeSelf.nixosProfiles.router
    flakeSelf.nixosProfiles.universal
    flakeSelf.nixosProfiles.nix-daemon

  ];

  nix.settings = {
    # when reaches 10MB
    min-free = "${toString (10 * 1024 * 1024)}";
    # free 500MB
    max-free = "${toString (500 * 1024 * 1024)}";

  };

  documentation.man.enable = true;

  # mkForce ?
  environment.systemPackages = with pkgs; [
    # disabled for now to reduce memory print
    # flashrom # to be able to flash the bios see https://teklager.se/en/knowledge-base/apu-bios-upgrade/
    # dmidecode # to get version of the bios: dmidecode -t bios
    btop
    iw
    iwd # contains iwmon
    # pkgs.wirelesstools # to get iwconfig
    # pkgs.tshark too heavy

    # to wake up desktop
    pkgs.ethtool
    pkgs.just # might be too muich
    pkgs.wolli
  ];

  home-manager.users.root = {
    imports = [
    #   flakeSelf.homeProfiles.neovim-minimal
      flakeSelf.homeModules.neovim
      flakeSelf.homeProfiles.readline
    ];
    home.stateVersion = "26.05";

  };

  # TODO use from flake or from unstable
  # services.opensnitch-ui.enable
  home-manager.users.teto = {
    home.stateVersion = "26.05";
    # TODO it should load the whole folder
    imports = [
      flakeSelf.homeModules.neovim
      flakeSelf.homeProfiles.readline
    ];

    home.packages = [
      pkgs.systemctl-tui
    ];

    home.file."justfile".text = ''
      # reveiller le desktop
      wakejedha:
        sudo wolli --iface enp2s0 ${secrets.jedha.wiredMac}

      # flasher la cler (GCFFlasher -l)
      # selectionne le firmware  ici https://deconz.dresden-elektronik.de/deconz-firmware/
      # deCONZ_ConBeeII_0x26780700.bin.GCF is a shitty one that makes conbee2 enter a restart loop over usb
      # last working one is deCONZ_ConBeeII_0x26720700.bin.GCF
      conbee-flasher:
        nix shell nixpkgs#gcfflasher
    '';
  };

  services.journald.settings.Journal = {
    # alternatively one can run journalctl --vacuum-time=2d
    SystemMaxUse = "200M";
  };

  # Use the GRUB 2 boot loader.
  # You cannot have duplicated devices in mirroredBoots
  boot.loader.grub.enable = true;
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # for the live cd
  # isoImage.squashfsCompression = "zstd -Xcompression-level 5";

  users = {
    mutableUsers = false;

    users.teto = {
      packages = [
        # pciutils # for lspci
        # bridge-utils # pour  brctl
        # aircrack-ng
      ];
      extraGroups = [
        "wpa_supplicant"
      ];
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  # TODO why copy solene's blog explanation
  # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "copytoram"
    "console=ttyS0,115200"
    "iomem=relaxed" # to be able to flash rom from host !
  ];
  boot.supportedFilesystems = pkgs.lib.mkForce [
    "vfat"
    "xfs"
    "cifs"
  ];

  nix = {

    # trusted-users = [ "teto" ];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

  };

  # irqbalance is supposed to distribute hardware interrupts across processors
  # to increase perf
  services.irqbalance.enable = true;

  security.sudo.wheelNeedsPassword = false;

  services.acpid.enable = true;

  # following the guide https://nixos.wiki/wiki/Systemd-networkd


  # systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";

  time.timeZone = "Europe/Paris";

  system.stateVersion = "26.05";
}
