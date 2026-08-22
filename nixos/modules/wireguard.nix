{
  config,
  lib,
  pkgs,
  secrets,
  # withSecrets,
  ...
}:
let
  cfg = config.tetos.wireguard;

  inherit (lib.wireguard) mkPeerIp wgNetwork;
in
{
  options = {
    tetos.wireguard = {
      enable = lib.mkEnableOption "wireguard";

      id = lib.mkOption {
        # default = false;
        #
        type = lib.types.int;
        description = ''
          Number used to generate IP
        '';
      };

      publicKey = lib.mkOption {
        # default = false;
        type = lib.types.str;
        description = ''
          pubkey
        '';
      };

      privateKeyFile = lib.mkOption {
        type = lib.types.str;
        description = ''
          path towards file containing private peer key file
        '';
      };

      # a list of nixosConfigurations ?
      peers = lib.mkOption {
        # NixOS configuration values are module fixpoints.  Treat them as
        # opaque values instead of recursively traversing their attributes.
        type = lib.types.listOf lib.types.raw;
        default = [ ];
        description = ''
          list of nixos configurations that we should connect with
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.wireguard.interfaces.wg0 = {
      # "wg0" is the network interface name. You can name the interface arbitrarily.
      # we shall get rid of mkWireguardPeer
      # wg0 = lib.mkWireguardPeer {
      #   inherit (cfg) id publicKey privateKeyFile;
      # };
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "${mkPeerIp cfg.id}/24" ];
      listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      inherit (cfg) privateKeyFile;

      # map over peers
      # peers = if id == serverPeer.id then map mkPeer clientPeers else [ (mkPeer serverPeer) ];
      peers = lib.flip map cfg.peers (
        peer:
        let
          p = builtins.trace "Looking at ${peer.config.networking.hostName}" peer.config.tetos.wireguard;
        in
        {
          # lib.mkPeer {

          inherit (p) publicKey;

          persistentKeepalive = 25;
          # used to generate routing table, if central node (id ==1) we have routes towards all other peers
          # could be done depending on number of peer ?
          allowedIPs = if cfg.id == 1 then [ "${mkPeerIp p.id}/32" ] else [ wgNetwork ];

        }
        // lib.optionalAttrs (cfg.id != 1) {
          endpoint = "${secrets.jakku.ipv4}:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

        }
      );

    };

    # firewall.allowedUDPPorts = [
    #   51820 # wireguard
    # ];
    # networking.firewall = {
    #   allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
    # };

    # boot.extraModulePackages = with config.boot.kernelPackages; [ wireguard ];
    environment.systemPackages = [ pkgs.wireguard-tools ];

    # add wireguard peers
    networking.extraHosts = lib.wireguard.vpnHosts;

  };
}
