{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.tetos.wireguard;
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
        default = false;
        type = lib.types.str;
        description = ''
          pubkey
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
    networking.wireguard.interfaces = {
      # "wg0" is the network interface name. You can name the interface arbitrarily.
      wg0 = lib.mkWireguardPeer {
        inherit (cfg) id publicKey privateKeyFile;
      };

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

    # networking.wireguard.interfaces = lib.optionalAttrs withSecrets {
    #   # "wg0" is the network interface name. You can name the interface arbitrarily.
    #   wg0 = lib.mkWireguardPeer {
    #
    #     id = 3;
    #     privateKeyFile = "${secretsFolder}/wireguard/${config.networking.hostName}-wg.key";
    #   };
    # };

  };
}
