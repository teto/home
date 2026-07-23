{
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
  extraHosts = ''
    10.100.0.1   nextcloud.vps
    10.100.0.1   nextcloud.vpn

    10.100.0.1   jellyfin.vps
    10.100.0.1   immich.vps
  '';

}
