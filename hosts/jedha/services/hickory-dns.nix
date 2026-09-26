{
  config,
  lib,
  pkgs,
  ...
}:
let
  # These names are only used by clients on Jedha itself.
  # nginxAddress = "127.0.0.1";
  # nginxNames = lib.unique (
  #   lib.filter
  #     (
  #       name:
  #       name != "localhost"
  #       && builtins.match "[0-9]+(\\.[0-9]+){3}" name == null
  #       && builtins.match "[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*" name != null
  #     )
  #     (
  #       lib.concatLists (
  #         lib.mapAttrsToList (
  #           name: vhost:
  #           [ (if vhost.serverName == null then name else vhost.serverName) ] ++ vhost.serverAliases
  #         ) config.services.nginx.virtualHosts
  #       )
  #     )
  # );
in
{
  enable = true;

  # TODO pass extraFlags like zonedir to systemd service

  settings = {
    # Bind separately from systemd-resolved's 127.0.0.53 stub.
    listen_addrs_ipv4 = [
      "127.0.0.1" 
      # unbinding conflicts with resolved ?
      # "0.0.0.0" 

    ];
    listen_addrs_ipv6 = [ ];

    # With only an allow list, every other client is refused
    allow_networks = [ 
      "127.0.0.0/8"
      "192.168.1.0/24" 
    ];

    # Exact-name zones avoid taking authority over unrelated .home names.
    # zones are freeform
    ## The zone origin; a trailing '.' is implied.
    # https://hickory-dns.org/config/#running-the-server
    # A forwarder is an External zone with a forward store. Use zone = "." to forward every query, or a narrower name to forward only that part of the tree.

      # map (name: {
      #   zone = name;
      #   zone_type = "Primary";
      #   file = pkgs.writeText "nginx-${name}.zone" ''
      #     $ORIGIN ${name}.
      #     $TTL 300
      #     @ IN SOA ns.${name}. hostmaster.${name}. (1 3600 600 86400 300)
      #     @ IN NS ns.${name}.
      #     @ IN A ${nginxAddress}
      #     ns IN A ${nginxAddress}
      #   '';
      # }) nginxNames
      # ++ [

# [[zones]]
# zone = "."
# zone_type = "External"
#
# [[zones.stores]]
# [[zones.stores]]
# type = "recursor"
# roots = "default/root.zone"
    zones = [

      # {
# type = "blocklist"
# lists = ["default/blocklist.txt", "default/blocklist2.txt"]
# wildcard_match = true
# min_wildcard_depth = 2
# sinkhole_ipv4 = "192.0.2.1"
# sinkhole_ipv6 = "::ffff:c0:0:2:1"
# block_message = "This query has been blocked by the DNS server"
# log_clients = false
# }
{
          zone = ".";
          zone_type = "External";
          stores = {
            type = "forward";
            # Use the router directly, never /etc/resolv.conf (which points here).
            name_servers = [
              {
                ip = "192.168.1.254";
                trust_negative_responses = false;
                connections = [
                  { protocol.type = "udp"; }
                  { protocol.type = "tcp"; }
                ];
              }
            ];
          };
        }
      {
          zone = "jedha.home";
          zone_type = "Primary";
          # Source of Authority is mandatory ?
          # @ IN SOA ns.${name}. hostmaster.${name}. (1 3600 600 86400 300)
# ; Définition du TTL par défaut (en secondes) et de l'origine
# $TTL 86400
# $ORIGIN example.com.
#
# ; Enregistrement SOA (Start of Authority) - Début d'autorité
# @   IN  SOA ns1.example.com. admin.example.com. (
#         2026092601 ; Numéro de série (AAAAJJMMPP)
#         3600       ; Rafraîchissement (Refresh)
#         1800       ; Nouvelle tentative (Retry)
#         604800     ; Expiration (Expire)
#         86400 )    ; TTL négatif minimum (Minimum TTL)
file = let 

    # 192.168.1.83
    genZone = name: pkgs.writeText "${name}.zone" ''
          $ORIGIN jedha.home.
          $TTL 300
          @ IN SOA ns.${name}. hostmaster.${name}. (1 3600 600 86400 300)
          @ IN NS ns.${name}.

          piper           CNAME   jedha.home.
          faster-whisper  CNAME   jedha.home.
        '';
          # @ IN CNAME piper.jedha.home. jedha.home.
          # @ IN CNAME faster-whisper.jedha.home. jedha.home.

        in genZone "jedha";
          # stores = {
          #   type = "forward";
          #   # Use the router directly, never /etc/resolv.conf (which points here).
          #   # name_servers = [
          #   #   {
          #   #     ip = "192.168.1.254";
          #   #     trust_negative_responses = false;
          #   #     connections = [
          #   #       { protocol.type = "udp"; }
          #   #       { protocol.type = "tcp"; }
          #   #     ];
          #   #   }
          #   # ];
          # };
        }
      ];
  };
}
