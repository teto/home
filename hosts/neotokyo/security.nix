{
  config,
  rootCaPath,
  secrets,
  lib,
  withSecrets,
  ...
}:
let
  stepcaServer = "https://localhost:${toString config.services.step-ca.port}/acme/acme/directory";
in
{

  pki.certificateFiles = [
    rootCaPath
  ];

  # see https://gquetel.fr/misc/step-ca-nixos/
  acme = {
    acceptTerms = true;
    # defaults.email = "cert+admin@example.com";
    # config.security.acme.
    defaults =
      lib.optionalAttrs withSecrets {
        email = secrets.jakku.email;
      }
      // {
        validMinDays = 15; # to avoid the warning email from letsencrypt
        # security.acme.defaults.credentialFiles
        # Environment variables suffixed by “_FILE” to set for the cert’s service for your selected dnsProvider. To find out what values you need to set, consult the documentation at https://go-acme.github.io/lego/dns/[1] for the corresponding
        # dnsProvider. This allows to securely pass credential files to lego by leveraging systemd credentials.
      };

    /*
      we are trying to generate a multidomain certificate here,
      inspired by:
      - https://discourse.nixos.org/t/nixos-nginx-acme-ssl-certificates-for-multiple-domains/19608/3
      - https://discourse.nixos.org/t/setup-a-wildcard-certificate-with-acme-on-a-custom-domain-name-hosted-by-powerdns/15055/6
    */
    certs =
      lib.optionalAttrs withSecrets {
        "blog.${secrets.jakku.hostname}" = {
          # blog.${secrets.jakku.hostname}
          # webroot = acmeRoot;
          # email = secrets.jakku.email;

          webroot = "/var/lib/acme/acme-challenge/";
          enableDebugLogs = true;
          group = "nginx";

          extraDomainNames = [
            # "blog.${secrets.jakku.hostname}"
            "www.${secrets.jakku.hostname}"
            "${secrets.jakku.hostname}"
            # "nextcloud.vps" # acme can't register for unknown TLDs
          ];
        };

      }
      // {

        "nextcloud.vps" = {

          # look for step-ca
          server = stepcaServer;
          webroot = "/var/lib/acme/acme-challenge/";
          enableDebugLogs = true;
        };

        # todo then do the same for jellyfin ?
        "immich.vps" = {

          # look for step-ca
          server = "https://localhost:${toString config.services.step-ca.port}/acme/acme/directory";
          webroot = "/var/lib/acme/acme-challenge/";
          enableDebugLogs = true;
        };

      };
  };

  # Enable 'sudo' with SSH key
  # see https://github.com/serokell/deploy-rs/issues/299#issuecomment-3179359719
  # to avoid password when using deploy-rs
  pam.sshAgentAuth = {
    enable = true;
  };
  # sudo.wheelNeedsPassword = true;
  sudo.execWheelOnly = true;
  sudo.extraRules = [
    {
      users = [ "teto" ];
      commands = [
        { command = "/nix/store/*-activatable-nixos-system-*/activate-rs"; }
        { command = "/run/current-system/sw/bin/rm /tmp/deploy-rs-canary-*"; }
      ];
    }
  ];

}
