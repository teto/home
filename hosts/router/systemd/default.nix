let

  bridgeNetwork = {
    address = "10.0.0.0";
    prefixLength = 24;
  };

  # todo rely on a lib to manipulate network
  # show = at: "${at.address}/${toString at.prefixLength}";

  # externalInterface = "wlan0";

in
{
  systemd.network = {
    enable = true;

    wait-online.enable = false;

    # SYSTEMD_LOG_LEVEL=debug
    wait-online = {
      timeout = 20;

      # interfaces to be ignored when declaring online status
      ignoredInterfaces = [ 
        "enp1s0"  # ignored as upstream
      ];
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
      br0 = {
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
      "50-wg0" = {
        matchConfig.Name = "wg0";
        networkConfig.MulticastDNS = false;
      };

      "10-enp1s0" = {
        matchConfig.Name = "enp1s0";
        networkConfig.DHCP = "ipv4";
        # try ?
        networkConfig.MulticastDNS = true;
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
        # networkConfig.IgnoreCarrierLoss = "3s";
        networkConfig.Description = "WAN port";
        networkConfig.MulticastDNS = true;
        linkConfig.RequiredForOnline = true;

      };
      # "10-wired-wan" = {
      #   matchConfig.Name = "lan";
      #   networkConfig.DHCP = "ipv4";
      # };
      br0 = {
        matchConfig.Name = "br0";
        # address = [ ];
        networkConfig.Address = "10.0.0.1/${toString bridgeNetwork.prefixLength}";

        # networkConfig.Gateway = "${bridgeNetwork.address}";
        # networkConfig.DHCP = "ipv4";
        networkConfig.DHCPServer = true;
        networkConfig.IPMasquerade = "ipv4";
        networkConfig.MulticastDNS = true;

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
      "10-enp4s0" = {
        matchConfig.Name = "enp4s0";
        networkConfig.Bridge = "br0";
      };

    };
  };
}
