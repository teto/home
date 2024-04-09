{ config, lib, pkgs
, secrets
, ... }:
let 
  # 52.28.201.89
  endpoint = "${secrets.nova.relay.prod.hostname}:51820";
in
{
  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };

  # boot.extraModulePackages = with config.boot.kernelPackages; [ wireguard ];
  environment.systemPackages = [
    pkgs.wireguard-tools
  ];

  # Enable WireGuard
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      # TODO TO override on a per host basis
      # ips = [ "10.100.0.3/24" ];
      listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "${secrets.secretsFolder}/nova-wg.key";

      peers = [
        # For a client configuration, one peer entry for the server will suffice.

        {
          # Public key of the server (not a file path).
          publicKey = secrets.nova.relay.prod.wireguardPublicKey;

          # set to 0.0.0.0 to forward all the traffic via VPN.
          # allowedIPs = [ "10.100.0.0/0" ];
          # Or forward only particular subnets
          allowedIPs = secrets.nova.wireguard.allowedIPs;

          # Set this to the server IP and port.
          
          # kh1.vault.dev.jinko.ai
          inherit endpoint;
          # endpoint = "10.100.0.1:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 45;
        }
      ];
    };
  };
}

