/*
small reminder about syntax

- "@" is the zone’s root
- "IN" means "INTERNET"

*/
{
  pkgs,
  ...
}:
{
  enable = false;

  # TODO pass extraFlags like zonedir to systemd service
  validateConfig = true;

  settings = {
    # Bind separately from systemd-resolved's 127.0.0.53 stub.
    # listen_addrs_ipv4 = [
    #   # "127.0.0.1" 
    #   # unbinding conflicts with resolved ?
    #   # "0.0.0.0" 
    #   # routerIp
    # ];
    listen_addrs_ipv6 = [ ];
    listen_port = 153;

    # With only an allow list, every other client is refused
    # allow_networks = [ 
    #   "127.0.0.0/8"
    #   "192.168.1.0/24" 
    # ];

    # Exact-name zones avoid taking authority over unrelated .home names.
    # zones are freeform
    ## The zone origin; a trailing '.' is implied.
    # https://hickory-dns.org/config/#running-the-server
    # A forwarder is an External zone with a forward store. Use zone = "." to forward every query, or a narrower name to forward only that part of the tree.


# [[zones.stores]]
# type = "recursor"
# roots = "default/root.zone"
    zones = [

      # use stevenblack-blocklist
      # blocklist est au format de 
      {
        zone = ".";
        zone_type = "External";
        stores = [
          {
          zone_type = "blocklist";
          lists = [
            "${pkgs.stevenblack-blocklist}/hosts"
          ];
          wildcard_match = true;
          min_wildcard_depth = 2;
          sinkhole_ipv4 = "0.0.0.0";
          # sinkhole_ipv6 = "::ffff:c0:0:2:1";
          block_message = "This query has been blocked by the DNS server";
          log_clients = false;
          }

          {

          type = "forward";
          # Use the router directly, never /etc/resolv.conf (which points here).
          name_servers = [
            {
              # use gandi NS server ?
              ip = "2312";
              trust_negative_responses = true;
              connections = [
                { protocol.type = "udp"; }
                { protocol.type = "tcp"; }
              ];
            }
          ];
          }
        ];
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

            # use @ to refer to current ?
              genZone = name: pkgs.writeText "${name}.zone" ''
                    $ORIGIN jedha.home.
                    $TTL 300
                    @ IN SOA ns.${name}. hostmaster.${name}. (1 3600 600 86400 300)
                    @ IN NS ns.${name}.
                    @  IN A ${jedhaIp}

                    piper           CNAME   jedha.home.
                    faster-whisper  CNAME   jedha.home.
                    cache           CNAME   jedha.home.
                    llamacpp        CNAME   jedha.home.
                    @               SRV     .
                  '';
#                   ; _Service._Proto.Name TTL Class SRV Priority Weight Port Target
# server          SRV     1 1 443 alias

                    # @ IN CNAME piper.jedha.home. jedha.home.
                    # @ IN CNAME faster-whisper.jedha.home. jedha.home.

          in 
            genZone "jedha";
        }
    ];
  };
}

