{
  lib,
  pkgs,
  config,
  flakeSelf,
  withSecrets,
  secrets,
  ...
}:
{

  # SHould be a level instead ?
  # enableStrictShellChecks = true;

  services =
    lib.mkIf config.services.pixiecore.enable {
      # force manual start ?!
      pixiecore.wantedBy = lib.mkForce [ ];

      # you can try this at runtime
      # systemctl service-log-level systemd-networkd debug
      systemd-tmpfiles-setup.serviceConfig = {
        LogLevelMax = "debug"; # or "info" for less verbose output
      };
    }
    // lib.mkIf config.services.netdata.enable {
      netdata.path = [ pkgs.linuxPackages.nvidia_x11 ];

    }
    // (
      let
        # port ?
        hassUri = flakeSelf.nixosConfigurations.router.config.services.home-assistant.uri;
        # toString slib.ports.home-assistant
        hassPort = 8123;
      in
      {
        # copied from https://github.com/NixOS/nixpkgs/pull/544252
        # lib.recursiveUpdate slib.systemd.serviceDefaults {
        speech-to-phrase = {
          after = [ "home-assistant.service" ];
          script = lib.concatStringsSep " " [
            (lib.getExe pkgs.speech-to-phrase)
            "--models-dir"
            "\"$STATE_DIRECTORY/models\""
            "--train-dir"
            "\"$STATE_DIRECTORY/train\""
            # "--custom-sentences-dir" ""
            "--uri 'tcp://127.0.0.1:10400'"
            "--hass-websocket-uri"
            "ws://127.0.0.1:${hassPort}/api/websocket"
            "--retrain-on-start"
            "--retrain-on-connect"
            "--retrain-seconds"
            "300"
          ];
          serviceConfig = {
            EnvironmentFile = config.sops.templates."speech-to-phrase/environment".path;
            Group = "speech-to-phrase";
            StateDirectory = "speech-to-phrase";
            User = "speech-to-phrase";
            # TODO: hardening
          };
        };

      }
    );

  # just to test
  # https://www.freedesktop.org/software/systemd/man/latest/systemd-sysupdate.html
  sysupdate.enable = false;

  network = {

    wait-online = {
      # not sure why it keeps failing
      enable = false;

      # Only controls boot waiting; does not disable DHCP.
      # ignoredInterfaces = [ "enp11s0" ];
      anyInterface = true;
      timeout = 60;
    };

    networks =
      lib.optionalAttrs withSecrets {
        "10-disable-wlan1" = {
          matchConfig.PermanentMACAddress = "${secrets.jedha.mediatekMacAddress}";
          linkConfig.ActivationPolicy = "always-down";
        };
      }
      //

      {
        "50-wg0" = {
          matchConfig.Name = "wg0";
          networkConfig.MulticastDNS = false;
        };

        # was actually overruled by networking.interfaces !
        # "10-wired" = {
        #   # matchConfig = {
        #   #   Name = "enp11s0";
        #   # };
        #   #
        #   # networkConfig = {
        #   #   DHCP = "yes";
        #   #   # only yes / no
        #   #   # DHCPServer = "yes";
        #   #   # IPMasquerade = "ipv4";
        #   #   # RequiredForOnline = "no";
        #   # };
        #
        #   # addresses = [
        #   #   # {
        #   #   #   Address = "10.0.0.1/24";
        #   #   # }
        #   # ];
        #
        #   # dhcpV4Config = {
        #   #   # UseDNS = true;
        #   #   # UseRoutes = true;
        #   # };
        #
        #   # dhcpServerConfig = {
        #   #   # Gateway = "10.0.0.1";
        #   #   # DNS = "192.168.1.254";
        #   #   # Weird that I would advertise this ?
        #   #   # DNS = "1.1.1.1";
        #   #   EmitDNS = true;
        #   #   PoolOffset = 50;
        #   #   PoolSize = 40;
        #   # };
        #
        #
        #   # dhcpServerStaticLeases = [
        #   #             {
        #   #               Address = "10.0.0.1";
        #   #               MACAddress = "65:43:4a:5b:d8:5f";
        #   #             }
        #   #           ];
        # };

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
