/*
  the router is an APU4D4, i.e., x86-based system
  https://teklager.se/en/products/routers/apu4d4-open-source-router

  Links of interest:
  - https://dataswamp.org/~solene/2022-08-03-nixos-with-live-usb-router.html
  - https://skogsbrus.xyz/blog/2022/06/12/router/
  - https://francis.begyn.be/blog/nixos-home-router
  - https://www.jjpdev.com/posts/home-router-nixos/

  systemd is advertised on the matrix:nixos-router so:
  - the guide https://nixos.wiki/wiki/Systemd-networkd

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
let

  bridgeNetwork = {
    address = "10.0.0.0";
    prefixLength = 24;
  };

  # todo rely on a lib to manipulate network
  show = at: "${at.address}/${toString at.prefixLength}";

  # externalInterface = "wlan0";

in
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
    ./services/openssh.nix
    ./services/home-assistant.nix
    ./services/zigbee2mqtt.nix
    # ./services/mqtt.nix

    # TODO replace with systemd mdns
    # flakeSelf.nixosProfiles.avahi
    flakeSelf.nixosProfiles.router
    flakeSelf.nixosProfiles.universal

  ];

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
    # imports = [
    #   flakeSelf.homeProfiles.neovim-minimal
    # ];
    home.stateVersion = "26.05";

  };

  # TODO use from flake or from unstable
  # services.opensnitch-ui.enable
  home-manager.users.teto = {
    home.stateVersion = "26.05";
    # TODO it should load the whole folder
    imports = [
      # flakeSelf.homeModules.teto-nogui
      flakeSelf.homeModules.neovim
      flakeSelf.homeProfiles.readline
    ];

    home.packages = [
      pkgs.systemctl-tui
    ];
    # package-sets.wifi = true;

    # wakeonlan ${secrets.jedha.ethernetMac}
    home.file."justfile".text = ''
      wakejedha:
        sudo wolli --iface enp2s0 9c:6b:00:8b:2a:c8 --broadcast 255.255.255.255
    '';
  };

  services.journald.extraConfig = ''
    # alternatively one can run journalctl --vacuum-time=2d
    SystemMaxUse=200MB
  '';

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

  # boot.kernel.sysctl = {
  #   # to not provoke the kernel into crashing
  #   # "net.ipv4.tcp_timestamps" = 0;
  #   # "net.ipv4.ipv4.ip_forward" = 1;
  #   # "net.ipv4.tcp_keepalive_time" = 60;
  #   # "net.core.rmem_max" = 4194304;
  #   # "net.core.wmem_max" = 1048576;
  # };

  # # creates problem with buffalo check if it blocks requests or what
  # # it is necessary to use dnssec though :(
  # networking.resolvconf.dnsExtensionMechanism = false;
  # networking.resolvconf.dnsSingleRequest = false;

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

  services.unbound = {
    enable = false;
    settings = {
      server = {
        interface = [
          "127.0.0.1"
          "10.42.42.42"
        ];
        access-control = [
          "0.0.0.0/0 refuse"
          "127.0.0.0/8 allow"
          "${show bridgeNetwork} allow"
        ];
      };
    };
  };

  # this takes a lot of space ! use cacti instead !
  # services.munin-node = {
  #     enable = true;
  # #     extraConfig = ''
  # #     allow ^63\.12\.23\.38$
  # #     '';
  # };

  # following the guide https://nixos.wiki/wiki/Systemd-networkd

  systemd.network = {
    enable = true;

    wait-online.enable = false;

    # SYSTEMD_LOG_LEVEL=debug
    wait-online = {
      timeout = 20;

      # interfaces to be ignored when declaring online status
      ignoredInterfaces = [ "enp1s0" ];
    };

    # example
    # systemd.network.links."10-custom_name" = {
    # matchConfig.MACAddress = "52:54:00:12:01:01";
    # linkConfig.Name = "custom_name";
    # };

    links = {
      "10-enp1s0" = {
        matchConfig.OriginalName = "enp1s0";
        # "ether", "loopback", "wlan", "wwan"
        # matchConfig.Type = "ether";
      };
      # externalInterface / wanInterface
      # "10-wlp5s0" = {
      #   matchConfig.OriginalName = "wlan0";
      #   # linkConfig.MTUBytes = "1442";
      # };

    };

    netdevs = {

      # man systemd.netdev
      "br0" = {
        # match
        netdevConfig.Name = "br0";
        netdevConfig.Kind = "bridge";
        # interfaces = [ "enp2s0" "enp3s0" "enp4s0" ];
        # bridgeConfig

      };

    };

    # [NetDev]
    # Name=br0
    # Kind=bridge

    networks = {
      "10-enp1s0" = {
        matchConfig.Name = "enp1s0";
        networkConfig.DHCP = "ipv4";
      };

      "10-wireless-wan" = {
        matchConfig.Name = "wlp5s0";
        # [Match]
        # Name=Nom de l'interface
        # MACAddress=Adresse MAC de l'interface
        # 04:f0:21:90:b2:78

        networkConfig.DHCP = "ipv4";
        networkConfig.IPv6AcceptRA = "no";
        networkConfig.LinkLocalAddressing = "ipv4";
        networkConfig.IgnoreCarrierLoss = "3s";
        networkConfig.Description = "WAN port";
        networkConfig.MulticastDNS = true;
        linkConfig.RequiredForOnline = true;

      };
      # "10-wired-wan" = {
      #   matchConfig.Name = "lan";
      #   networkConfig.DHCP = "ipv4";
      # };
      "br0" = {
        matchConfig.Name = "br0";
        # address = [
        # ];
        networkConfig.Address = "10.0.0.1/${toString bridgeNetwork.prefixLength}";
        # routes = [
        #   { routeConfig = { Destination = "64:ff9b::/96"; Gateway = "2001:db8::1"; }; }
        # ];

        # networkConfig.Gateway = "${bridgeNetwork.address}";
        # networkConfig.DHCP = "ipv4";
        networkConfig.DHCPServer = true;
        networkConfig.IPMasquerade = "ipv4";

        dhcpServerConfig = {
          PoolOffset = 100;
          PoolSize = 40;
          EmitDNS = true;
          # ServerAddress
          # EmitNTP
          # EmitTimeZone
          # SendOption

          # DefaultLeaseTimeSec=, MaxLeaseTimeSec=
          # the ISP box address

          # nom DNS visible dans "Mode reseau" sur freebox os
          DNS = "freebox-server";
          # DNS = "192.168.1.1";
        };

        # lui meme
        networkConfig.DHCP = "ipv4";

      };

      "10-enp2s0" = {
        matchConfig.Name = "enp2s0";
        networkConfig.Bridge = "br0";
      };
      "10-enp3s0" = {
        matchConfig.Name = "enp3s0";
        networkConfig.Bridge = "br0";
      };

      # remove once we make sure everything works
      # "10-enp4s0" = {
      #   matchConfig.OriginalName = "enp4s0";
      #   networkConfig.Bridge = "br0";
      # };

    };
  };

  # systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";
  # services.dhcpd4 = {
  #   enable = true;

  #   # TODO FIX
  #   extraConfig = ''
  #   option subnet-mask 255.255.255.0;
  #   # L'option routers spécifie une liste d'adresses IP de routeurs qui sont sur le sous-réseau du client. Les routeurs doivent être mentionnés par ordre de préférence.
  #   option routers ${bridgeNetwork.address};
  #   option domain-name-servers 192.168.1.1;
  #   subnet ${bridgeNetwork.address} netmask 255.255.255.0 {
  #       range 10.0.0.100 10.0.0.199;
  #   }
  #   '';
  #   interfaces = [ "br0" ];
  # };

  time.timeZone = "Europe/Paris";

  services.resolved.settings.Resolve.MulticastDNS = true;

  # TODO bump it
  system.stateVersion = "26.05";
}
