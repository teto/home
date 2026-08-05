/*
  https://wiki.nixos.org/wiki/WireGuard
  sudo networkctl up wg0
  https://github.com/PaulGrandperrin/nix-systems/blob/main/nixosModules/shared/wireguard.nix
*/

{
  config,
  lib,
  # pkgs,
  secretsFolder,
  secrets,
  withSecrets ? false,
  ...
}:
{

  # enable = false;

  # interfaces.wg = {
  #   ips = [ "10.100.0.2/24" ];
  # };

  interfaces = lib.optionalAttrs withSecrets {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = lib.mkWireguardPeer {

      id = 3;
      privateKeyFile = "${secretsFolder}/wireguard/${config.networking.hostName}-wg.key";
    };
    # {
    #   # Determines the IP address and subnet of the client's end of the tunnel interface.
    #   ips = [ "10.100.0.3/24" ];
    #   listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)
    #
    #   # Path to the private key file.
    #   #
    #   # Note: The private key can also be included inline via the privateKey option,
    #   # but this makes the private key world-readable; thus, using privateKeyFile is
    #   # recommended.
    #   privateKeyFile = "${secretsFolder}/wireguard/jedha-private-key";
    #
    #   # TODO add tatooine peer
    #   peers = [
    #
    #     # For a client configuration, one peer entry for the server will suffice.
    #     {
    #       # Public key of the server (not a file path).
    #       publicKey = "1uhd6iscyFt68twrVz+y4zvws5PzhpIuY4rrr4N/Ymk=";
    #
    #       # Forward all the traffic via VPN.
    #       # allowedIPs = [
    #       # "0.0.0.0/0"
    #       # ];
    #       # Or forward only particular subnets
    #       allowedIPs = [
    #         "10.100.0.0/24"
    #         # "91.108.12.0/22"
    #       ];
    #
    #       # Set this to the server IP and port.
    #       # IP of jakku.hostname
    #       # todo move it to secrets
    #       endpoint = "${secrets.jakku.ipv4}:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
    #
    #       # Send keepalives every 25 seconds. Important to keep NAT tables alive.
    #       persistentKeepalive = 25;
    #     }
    #   ];
    # };
  };
}
