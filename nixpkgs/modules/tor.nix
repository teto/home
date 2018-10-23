{ config, lib, pkgs,  ... }:
{

  services.tor = {
    enable = false;
    client.enable = true;
    enableGeoIP = true;
    dns.enable = false; # default false
    relay.enable = false;

    hiddenServices = { "my-hidden-service-example".map = [
        { port = 22; }                # map ssh port to this machine's ssh
        { port = 80; toPort = 8080; } # map http port to whatever runs on 8080
        { port = "sip"; toHost = "mail.example.com"; toPort = "imap"; } # because we can
      ];
    };
  };
}

