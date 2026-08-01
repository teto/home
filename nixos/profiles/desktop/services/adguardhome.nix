{
  # COMPARE with competitot "blocky"
  enable = true;

  # allow to change settings from webserver
  # mutableSettings = true;
  openFirewall = false;

  # default is 3000
  # annoys
  port = 8084;

  # mutableSettings = true;
  # extraArgs = [];

  # https://github.com/AdguardTeam/AdGuardHome/wiki/Configuration#configuration-file
  #   settingsFormat = pkgs.formats.yaml { };
  # careful this can easily break
  settings = {
    # List of DNS servers used for initial hostname resolution in case an upstream server name is a hostname.
    dns.bootstrap_dns = [
      "127.0.0.1"
    ];

    dns.upstream_dns = [
      # HACK this works only in this location
      "192.168.1.254" # router
      "192.168.1.14" # router

    ];

    users = [ ];

    filtering = {
      rewrites = [
        {
          domain = "*.vps";
          answer = "10.100.0.1";
          enabled = true;
        }
      ];
    };
    # 'rewrites':
    #   - 'domain': example.com
    #     'answer': 127.0.0.1
    #   - 'domain': '*.example.com'
    #     'answer': A
    # dhcp = {
    # local_domain_name = "lan";
    # };
  };
}
