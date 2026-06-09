{
  config,
  # , secretsFolder
  ...
}:
{
  # enable = true;

  # what's the diff with networking.useNetworkd ?
  network = {
    enable = true;

    networks."50-wg0" = {
      networkConfig = {
        # do not use IPMasquerade,
        # unnecessary, causes problems with host ipv6
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };
    };

    # https://wiki.nixos.org/wiki/WireGuard#Peer_setup
    # networks."50-wg0" = {
    #   matchConfig.Name = "wg0";
    #
    #   address = [
    #     # /32 and /128 specifies a single address
    #     # for use on this wg peer machine
    #     "fd31:bf08:57cb::7/128"
    #     "192.168.26.7/32"
    #   ];
    # };

    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };

      wireguardConfig = {
        ListenPort = 51820;

        # ensure file is readable by `systemd-network` user
        PrivateKeyFile = config.sops.secrets.wg-private-key.path;
        # PrivateKeyFile = "${secretsFolder}/wireguard/tatooine-private-key";

        # To automatically create routes for everything in AllowedIPs,
        # add RouteTable=main
        RouteTable = "main";

        # FirewallMark marks all packets send and received by wg0
        # with the number 42, which can be used to define policy rules on these packets.
        FirewallMark = 42;
      };

      wireguardPeers = [
        {
          # todo set the peer public key ?
          PublicKey = "HPrWcZUuJMsxc+qDrN08IC9GJoy/c1UofmvmTC/bm3U=";

          # Each peer can handle traffic destined for a certain IP range. This range is called AllowedIP.
          AllowedIPs = [
            "10.100.0.0/24"
          ];
          # Endpoint = "192.168.1.26:51820";

          # RouteTable can also be set in wireguardPeers
          # RouteTable in wireguardConfig will then be ignored.
          # RouteTable = 1000;
        }
      ];
    };
  };
}
