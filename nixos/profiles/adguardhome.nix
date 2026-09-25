# to be included 
{
  # COMPARE with competitot "blocky"
  # enable = false;

  # allow to change settings from webserver
  # mutableSettings = true;
  # openFirewall = false;

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

    # https://adguard-dns.io/kb/fr/adguard-home/configuration/
    dns.upstream_dns = [
      # HACK this works only in this location
      "192.168.1.254" # router
      "[/home/]192.168.1.254" # can I reference _gateway there ?

    ];

    users = [ ];

    filtering = {
      rewrites = [
        {
          domain = "*.vps";
          answer = "10.100.0.1";
          enabled = true;
        }
        {
          domain = "*.jedha.home";
          answer = "jedha.home"; # resolved via /etc/hosts
          enabled = true;
        }
      ];
    };
    # dhcp = {
    # local_domain_name = "lan";
    # };

    filters = [
      {
        enabled = true;
        url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
        name = "AdGuard DNS filter";
        id = 1;
      }
    ];
    # filters:
    #   - enabled: true
    #     url: https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt
    #     name: AdGuard DNS filter
    #     id: 1
    #   - enabled: false
    #     url: https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt
    #     name: AdAway Default Blocklist
    #     id: 2
    #   - enabled: true
    #     url: https://adguardteam.github.io/HostlistsRegistry/assets/filter_53.txt
    #     name: AWAvenue Ads Rule
    #     id: 1785014247
    #   - enabled: true
    #     url: https://adguardteam.github.io/HostlistsRegistry/assets/filter_34.txt
    #     name: HaGeZi's Normal Blocklist
    #     id: 1785014248
    #   - enabled: true
    #     url: https://adguardteam.github.io/HostlistsRegistry/assets/filter_48.txt
    #     name: HaGeZi's Pro Blocklist
    #     id: 1785014249
    #   - enabled: true
    #     url: https://adguardteam.github.io/HostlistsRegistry/assets/filter_51.txt
    #     name: HaGeZi's Pro++ Blocklist
    #     id: 1785014250
    #   - enabled: true
    #     url: https://adguardteam.github.io/HostlistsRegistry/assets/filter_49.txt
    #     name: HaGeZi's Ultimate Blocklist
    #     id: 1785014251
    #   - enabled: true
    #     url: https://adguardteam.github.io/HostlistsRegistry/assets/filter_59.txt
    #     name: AdGuard DNS Popup Hosts filter
    #     id: 1789572140
    #   - enabled: true
    #     url: https://adguardteam.github.io/HostlistsRegistry/assets/filter_47.txt
    #     name: HaGeZi's Gambling Blocklist
    #     id: 1789572141
    #   - enabled: true
    #     url: https://adguardteam.github.io/HostlistsRegistry/assets/filter_63.txt
    #     name: HaGeZi's Windows/Office Tracker Blocklist
    #     id: 1789572142
    #   - enabled: true
    #     url: https://adguardteam.github.io/HostlistsRegistry/assets/filter_30.txt
    #     name: Phishing URL Blocklist (PhishTank and OpenPhish)
    #     id: 1789572143
  };
}

