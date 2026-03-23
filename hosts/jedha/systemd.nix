{
  lib,
  secrets,
  ...
}:
{

  services.pixiecore.wantedBy = lib.mkForce [ ];

  # you can try this at runtime
  # systemctl service-log-level systemd-networkd debug
  services.systemd-tmpfiles-setup.serviceConfig = {
    LogLevelMax = "debug"; # or "info" for less verbose output
  };

  # just to test
  # https://www.freedesktop.org/software/systemd/man/latest/systemd-sysupdate.html
  sysupdate.enable = false;

  network = {

    # links = {
    #   wired = {
    #     matchConfig = {
    #              Name = "enp11s0";
    #            };
    #   };
    #
    #   # wlp10s0
    #
    # };

    # netdevs = {
    #
    #   # wlp10s0
    #    wireless = {
    #      # add it to secrets
    #
    #      # security =
    #      netdevConfig = {
    #              # Kind = "bridge";
    #              # Name = "mybridge";
    #
    #        # Description = "toto";
    #       # SSID = "neotokyo";
    #       # KeyManagement = "wpa-psk";
    #      };
    #
    #       # wlanConfig = {
    #       #
    #       # };
    #       # Security = {
    #       #   Passphrase = secrets.router.password;
    #       # };
    #
    #       extraConfig = ''
    #
    #         [Security]
    #         Passphrase = toto
    #
    #         '';
    #
    #   };
    # };

    # enable = true;

    networks = {
      wired = {
        matchConfig = {
          Name = "enp11s0";
        };
        addresses = [
          {
            Address = "10.0.0.1/24";
          }
        ];
        # dhcpV4Config = {
        #   # UseDNS = true;
        #   # UseRoutes = true;
        # };
        networkConfig = {
          # only yes / no
          DHCPServer = "yes";
          # IPMasquerade = "ipv4";
          # RequiredForOnline = "no";
        };

        dhcpServerConfig = {

          # Gateway = "10.0.0.1";
          # DNS = "192.168.1.254";
          DNS = "1.1.1.1";
          EmitDNS = true;
          PoolOffset = 50;
          PoolSize = 40;

        };
        # Unmanaged=

        # dhcpServerStaticLeases = [
        #             {
        #               Address = "10.0.0.1";
        #               MACAddress = "65:43:4a:5b:d8:5f";
        #             }
        #           ];
      };

      # wlan = {
      #   name = "wlp10s0";
      #   # matchConfig = {
      #   #   Name = "wlp10s0";
      #   # };
      #   DHCP = "yes"; # "ipv4"
      #   networkConfig = {
      #              Description = "My Network";
      # Unmanaged=yes
      #            };
      # };
    };
  };
}
