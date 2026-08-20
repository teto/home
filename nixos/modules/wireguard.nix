{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.tetos.wireguard;

  wgNetwork = lib.wireguard.mkPeerIp "0";
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
        type = lib.types.any;
        description = ''
          path towards file containing private peer key file
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.wireguard.interfaces = {
      # "wg0" is the network interface name. You can name the interface arbitrarily.
      # we shall get rid of mkWireguardPeer
      wg0 = lib.mkWireguardPeer {
        inherit (cfg) id publicKey privateKeyFile;
      };
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "10.100.0.${toString cfg.id}/24" ];
      listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      inherit (cfg) privateKeyFile;

      # map over peers
      # peers = if id == serverPeer.id then map mkPeer clientPeers else [ (mkPeer serverPeer) ];
      peers = lib.flip map cfg.peers (p:
      lib.mkPeer {
          persistentKeepalive = 25;
        allowedIPs = if cfg.id == 1 then [  "${lib.mkPeerIp p.id}/32" ] else [ wgNetwork ];

      });

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
