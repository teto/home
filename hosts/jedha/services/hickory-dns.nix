{
  config,
  lib,
  pkgs,
  ...
}:
let
  # These names are only used by clients on Jedha itself.
  nginxAddress = "127.0.0.1";
  nginxNames = lib.unique (
    lib.filter
      (
        name:
        name != "localhost"
        && builtins.match "[0-9]+(\\.[0-9]+){3}" name == null
        && builtins.match "[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*" name != null
      )
      (
        lib.concatLists (
          lib.mapAttrsToList (
            name: vhost:
            [ (if vhost.serverName == null then name else vhost.serverName) ] ++ vhost.serverAliases
          ) config.services.nginx.virtualHosts
        )
      )
  );
in
{
  enable = true;

  settings = {
    # Bind separately from systemd-resolved's 127.0.0.53 stub.
    listen_addrs_ipv4 = [ "127.0.0.1" ];
    listen_addrs_ipv6 = [ ];
    allow_networks = [ "127.0.0.0/8" ];

    # Exact-name zones avoid taking authority over unrelated .home names.
    # Regex and wildcard nginx server names are deliberately excluded above.
    zones =
      map (name: {
        zone = name;
        zone_type = "Primary";
        file = pkgs.writeText "nginx-${name}.zone" ''
          $ORIGIN ${name}.
          $TTL 300
          @ IN SOA ns.${name}. hostmaster.${name}. (1 3600 600 86400 300)
          @ IN NS ns.${name}.
          @ IN A ${nginxAddress}
          ns IN A ${nginxAddress}
        '';
      }) nginxNames
      ++ [
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
      ];
  };
}
