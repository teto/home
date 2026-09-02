{ lib, ... }:
{
  # when under ndots in hostname, try resolution with those
  search = [
    ".local" 
    # ".vpn"
  ];

  # controls order in which glibc returns IP,
  # prefer ipv4
  getaddrinfo.precedence = {
    "::1/128" = 50;
    "::/0" = 40;
    "2002::/16" = 30;
    "::/96" = 20;
    "::ffff:0:0/96" = 100;
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
