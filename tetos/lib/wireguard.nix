{ lib, secrets, ... }:
let
  # my_conf = head (builtins.filter (e: e.hostname == my_hostname) peers);
  wgNetwork = "10.100.0.0/24";

  # Each peer can handle traffic destined for a certain IP range. This range is called AllowedIP.
  # Allowed IPs should be unique to each peer. If there are peers whose allowed IPs overlap, traffic will only reach one of them.

  serverPeer = {
    # neotokyo
    id = 1;
    publicKey = "1uhd6iscyFt68twrVz+y4zvws5PzhpIuY4rrr4N/Ymk=";
    # Set this to the server IP and port.
    # IP of jakku.hostname
    # todo move it to secrets
    endpoint = "${secrets.jakku.ipv4}:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

    # allowedIPs = [
    #   wgNetwork
    #   # "91.108.12.0/22"
    # ];
  };

  clientPeers = [
    {
      # jedha
      id = 3;
      publicKey = "Zr5Q5e2cN6pscnok0z8d30numWMlzud9LE4n0KSSczE=";

    }
    {
      # tatooine
      id = 2;
      publicKey = "HPrWcZUuJMsxc+qDrN08IC9GJoy/c1UofmvmTC/bm3U=";

    }
    {
      # router
      id = 4;
      publicKey = "3dWxfxRgzHuxzKK5Ez+u/mVcxfONt51ndaaVjYk+e2Q=";
    }
  ];

in
{
  # load data from json
  mkWireguardPeer =
    {
      id,
      # the default on desktops, but not on router or jakku
      privateKeyFile,
      ...
    }:
    let
      mkPeer =
        p:
        (removeAttrs p [ "id" ])
        // {

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
          allowedIPs = if id == 1 then [ "10.100.0.${toString p.id}/32" ] else [ wgNetwork ];
        };
    in

    {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "10.100.0.${toString id}/24" ];
      listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      inherit privateKeyFile;

      peers = if id == serverPeer.id then map mkPeer clientPeers else [ (mkPeer serverPeer) ];

      #   [
      #
      #   # For a client configuration, one peer entry for the server will suffice.
      #   {
      #     # Public key of the server (not a file path).
      #     inherit publicKey;
      #     # publicKey = "1uhd6iscyFt68twrVz+y4zvws5PzhpIuY4rrr4N/Ymk=";
      #
      #     # Forward all the traffic via VPN.
      #     # Or forward only particular subnets
      #     endpoint = "${secrets.jakku.ipv4}:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
    };
}
