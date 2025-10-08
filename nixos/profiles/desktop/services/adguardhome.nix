{
  # COMPARE with competitot "blocky"
  enable = true;

  # allow to change settings from webserver
  # mutableSettings = true;
  openFirewall = false;

  # default is 80
  port = 80;

  # https://github.com/AdguardTeam/AdGuardHome/wiki/Configuration#configuration-file
  settings =  {
    # List of DNS servers used for initial hostname resolution in case an upstream server name is a hostname.
    dns.bootstrap_dns = [ "127.0.0.1" ];
    users = [];
  };
}
