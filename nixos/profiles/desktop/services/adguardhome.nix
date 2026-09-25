{
  # COMPARE with competitot "blocky"
  enable = false;

  # allow to change settings from webserver
  # mutableSettings = true;
  openFirewall = false;

  # default is 3000
  # annoys
  port = 8084;

  # https://github.com/AdguardTeam/AdGuardHome/wiki/Configuration#configuration-file
  #   settingsFormat = pkgs.formats.yaml { };
  # careful this can easily break
  # settings = {
  #   # List of DNS servers used for initial hostname resolution in case an upstream server name is a hostname.
  #   dns.bootstrap_dns = [
  #     "127.0.0.1"
  #   ];
  #
  #   # https://adguard-dns.io/kb/fr/adguard-home/configuration/
  #   dns.upstream_dns = [
  #     # HACK this works only in this location
  #     "192.168.1.254" # router
  #     "[/home/]192.168.1.254" # can I reference _gateway there ?
  #
  #   ];
  #
  #   users = [ ];
  #
  #   filtering = {
  #     rewrites = [
  #       {
  #         domain = "*.vps";
  #         answer = "10.100.0.1";
  #         enabled = true;
  #       }
  #       {
  #         domain = "*.jedha.home";
  #         answer = "jedha.home"; # resolved via /etc/hosts
  #         enabled = true;
  #       }
  #     ];
  #   };
  #   # dhcp = {
  #   # local_domain_name = "lan";
  #   # };
  #
  #   filters = [
  #     {
  #       enabled = true;
  #       url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
  #       name = "AdGuard DNS filter";
  #       id = 1;
  #     }
  #   ];
  # };
}
