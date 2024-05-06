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
{ config, lib, pkgs, secrets, flakeInputs, ... }:
let

  bridgeNetwork = { address = "10.0.0.0"; prefixLength = 24; };

  # todo rely on a lib to manipulate network
  show = at:
    "${at.address}/${toString at.prefixLength}";

  externalInterface = "wlan0";

in
{
  # pcengines/apu/
  imports = [
    ./hardware.nix
    ../config-all.nix
    ./services/openssh.nix
    ../../nixos/profiles/router.nix

  ];

  environment.systemPackages = with pkgs; [
    flashrom # to be able to flash the bios see https://teklager.se/en/knowledge-base/apu-bios-upgrade/
    dmidecode # to get version of the bios: dmidecode -t bios
    bridge-utils
    wirelesstools
    iwd # contains iwmon
    pkgs.wirelesstools # to get iwconfig
    pkgs.tshark
    pkgs.wget
  ];


  home-manager.users.root = {
    imports = [
      ../../hm/profiles/neovim.nix
    ];
  };

  # TODO use from flake or from unstable
  # services.opensnitch-ui.enable
  home-manager.users.teto = {
    # TODO it should load the whole folder
    imports = [
      # ./teto/home.nix
      ./teto/nix.nix
      ../../hm/profiles/zsh.nix
      ../../hm/profiles/neovim.nix

      # breaks build: doesnt like the "activation-script"
      # nova.hmConfigurations.dev
    ];
  };

  services.journald.extraConfig = ''
    # alternatively one can run journalctl --vacuum-time=2d
    SystemMaxUse=200MB
    '';

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sdb"; # or "nodev" for efi only

  # for the live cd
  # isoImage.squashfsCompression = "zstd -Xcompression-level 5";

  users = {
    mutableUsers = false;

    users.teto.packages = [
      # pciutils # for lspci
      # bridge-utils # pour  brctl
      # aircrack-ng
    ];
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
  boot.kernelParams = [
    "copytoram"
    "console=ttyS0,115200"
    "iomem=relaxed" # to be able to flash rom from host !
  ];
  boot.supportedFilesystems = pkgs.lib.mkForce [ "vfat" "xfs" "cifs" ];

  # irqbalance is supposed to distribute hardware interrupts across processors
  # to increase perf
  services.irqbalance.enable = true;

  security.sudo.wheelNeedsPassword = false;

  services.acpid.enable = true;

  services.unbound = {
    enable = false;
    settings = {
      server = {
        interface = [ "127.0.0.1" "10.42.42.42" ];
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
    # SYSTEMD_LOG_LEVEL=debug
    wait-online = {
      timeout = 20;

      # interfaces to be ignored when declaring online status
      ignoredInterfaces = ["enp1s0" ];
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
        matchConfig.Name = "wlan0";
        networkConfig.DHCP = "ipv4";
        networkConfig.IPv6AcceptRA = "no";
        networkConfig.LinkLocalAddressing = "ipv4";
        networkConfig.IgnoreCarrierLoss = "3s";
        networkConfig.Description = "WAN port";
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
        #   services.resolved= {
        # enable = true;
        # dnssec = "false"; # "allow-downgrade";
        # };

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
          DNS = "192.168.1.1";
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
  networking = {
    useNetworkd = true;
    useDHCP = false;
    hostName = "router";
    # networking.dhcpcd.enable = true;
    usePredictableInterfaceNames = true;
    # networking.firewall.interfaces.enp1s0.allowedTCPPorts = [ 4949 ];

    firewall = {
      enable = false;
      interfaces.br0.allowedTCPPorts = [ 53 ];
      interfaces.br0.allowedUDPPorts = [ 53 ];
    };


    #   # address of the livebox
    #   defaultGateway = { address = "192.168.1.1"; interface = "wlp5s0"; };
    #  interfaces.enp1s0 = {
    #     useDHCP = true;
    #     # ipv4.addresses = [
    #     # { address = "192.168.1.127"; prefixLength = 24; }
    #     # ];
    #   };


    #   interfaces.wlp5s0 = {
    #     useDHCP = true;
    #     # ipv4.addresses = [
    #     # { address = "192.168.1.127"; prefixLength = 24; }
    #     # ];
    #   };

    #   interfaces.br0 = {
    #     ipv4.addresses = [
    #       bridgeNetwork
    #     ];
    #   };

    #   bridges.br0 = {
    #     interfaces = [ "enp2s0" "enp3s0" "enp4s0" ];
    #   };

    #   nat.enable = true;
    #   nat.externalInterface = externalInterface;
    #   nat.internalInterfaces = [ "br0" ];

    wireless = {
      # enable = true;
      # userControlled.enable = true;
      iwd = {
        enable = true;
        # https://iwd.wiki.kernel.org/networkconfigurationsettings
        settings = {
          Settings = { };
          Network = {
            EnableIPv6 = false;
          };
          Security = {
            Passphrase = secrets.router.password;
          };

          # psk = secrets.router.password;
        };
      };

      networks = {
        neotokyo = {
          psk = secrets.router.password;
          # appended to wpa_supplicant.conf
          # freq_list=5180 5190 5200 5210 5220 5230 5240 5250 5260 5270 5280
          # 

          #            freq_list=5180 5190 5200 5210 5220 5230 5240 5250 5260 5270 5280

          # extraConfig = ''
          #  bssid_whitelist=04:E3:1A:6A:CF:05
          #  '';
        };
      };
    };
  };

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

  system.stateVersion = "23.11";
}
