{
  # COMPARE with competitot "blocky"
  enable = true;

  # allow to change settings from webserver
  # mutableSettings = true;
  openFirewall = false;

  # default is 80
  # annoys 
  port = 8084;

  # https://github.com/AdguardTeam/AdGuardHome/wiki/Configuration#configuration-file
  settings =  {
    # List of DNS servers used for initial hostname resolution in case an upstream server name is a hostname.
    dns.bootstrap_dns = [ 
      "127.0.0.1" 
    ];
    dns.upstream_dns = [
      "192.168.1.254" # router
    ];

    users = [];

    # dhcp = {
    # local_domain_name = "lan";
    # };
  };
}
