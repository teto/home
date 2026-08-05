{
  lib,
  # pkgs,
  secrets,
  # , secretsFolder
  config,
  withSecrets ? false,
  ...
}:
lib.optionalAttrs (lib.debug.traceValFn (a: "SECRETS ? ${toString a}") withSecrets) {
  domain = secrets.jakku.domain;

}
// {
  # TODO fetch from secrets
  hostName = "neotokyo";

  domain = if withSecrets then secrets.jakku.domain else "toto";

  useNetworkd = true;
  # useDHCP = true;

  # without these overrides, seems like nginx selects wrong server
  extraHosts =
    let
      # interested in router mostly
      peer = builtins.head lib.wireguard.clientPeers;
    in
    ''
      ${lib.wireguard.mkPeerIp peer.id} ${peer.hostName} 
      10.100.0.3    tatooine.vpn
      10.100.0.3    jedha.vpn
      10.100.0.4    home-assistant.vpn
      10.100.0.1    jellyfin.vps
      10.100.0.1    immich.vps
      10.100.0.1    nextcloud.vps
    '';

  firewall = {
    enable = true;
    allowedUDPPorts = [
      51820 # wireguard
      # nope
      # config.networking.wireguard.interfaces.wg0.listenPort
    ];

    allowedTCPPorts = [
      # This is just a test to see if I can access directly via wireguard
      5000
    ];
  };

  nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "ens3";
    internalInterfaces = [ "wg0" ];
  };

  # https://wiki.nixos.org/wiki/WireGuard#Peer_setup
  wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = lib.mkWireguardPeer {
      id = 1;
      privateKeyFile = config.sops.secrets.wg-private-key.path;
    };

    #   {
    #   # Determines the IP address and subnet of the server's end of the tunnel interface.
    #   ips = [ "10.100.0.1/24" ];
    #
    #   # The port that WireGuard listens to. Must be accessible by the client.
    #   listenPort = 51820;
    #
    #   # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
    #   # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
    #   # postSetup = ''
    #   #   ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
    #   # '';
    #   #
    #   # # This undoes the above command
    #   # postShutdown = ''
    #   #   ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
    #   # '';
    #
    #   # Path to the private key file.
    #   #
    #   # Note: The private key can also be included inline via the privateKey option,
    #   # but this makes the private key world-readable; thus, using privateKeyFile is
    #   # recommended.
    #   privateKeyFile = config.sops.secrets.wg-private-key.path;
    #
    #   # TODO i could iterate over the various nixosConfigurations ? or add it to desktop ?
    #   peers = [
    #     # List of allowed peers.
    #     {
    #       # Feel free to give a meaningful name
    #       # Public key of the peer (not a file path).
    #       # "tatooine-private-key"
    #       publicKey = "HPrWcZUuJMsxc+qDrN08IC9GJoy/c1UofmvmTC/bm3U=";
    #
    #       # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
    #       allowedIPs = [ "10.100.0.2/32" ];
    #       persistentKeepalive = 45;
    #     }
    #     {
    #       # Feel free to give a meaningful name
    #       publicKey = "Zr5Q5e2cN6pscnok0z8d30numWMlzud9LE4n0KSSczE=";
    #
    #       # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
    #       allowedIPs = [ "10.100.0.3/32" ];
    #       persistentKeepalive = 45;
    #     }
    #   ];
    # };
  };
}
