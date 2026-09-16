{ lib, ... }:
{
  # when under ndots in hostname, try resolution with those
  search = [
    # Note that configuring the MulticastDNS domain "local" as search or routing domain has the effect of routing lookups for this domain to classic unicast DNS.
    # This may be used to provide compatibility with legacy installations that use this domain in a unicast DNS context, against the IANA assignment of this domain to pure MulticastDNS purposes.
    # Search and routing domains are a unicast DNS concept, they cannot be used to resolve single-label lookups via MulticastDNS.
    # "local"
    # freebox apparently uses "home" as dns now
    # https://www.geeek.org/freebox-dns-local-fonctionnement/
    "home"
    "vpn"
  ];

  # controls order in which glibc returns IP,
  # prefer ipv4
  # one can use "sortlist" from resolv.conf as well
  getaddrinfo = {
    enable = true;
    # only valid for libc
    precedence = {
      "::1/128" = 50;
      "::/0" = 40;
      "2002::/16" = 30;
      "::/96" = 20;
      "::ffff:0:0/96" = 100;

    };
    scopev4 = {
      # "::ffff:0.0.0.0/96" = 14;
      # "::ffff:127.0.0.0/104" = 2;
      # "::ffff:169.254.0.0/112" = 2;

    };
  };
  # add wireguard peers
  extraHosts = lib.wireguard.vpnHosts;

  # networking.firewall.checkReversePath = false; # for nixops
  firewall.allowedUDPPorts = [
    # we can do without ?
    5353 # mdns via resolved or avahi
  ];
  # firewall.allowedTCPPorts = [ 631 ];

}
