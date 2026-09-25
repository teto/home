/*
  I need some self-signed certificates for nextcloud client
  because I am using local TLDs, lets encrypt cant do
  https://gquetel.fr/misc/step-ca-nixos/
  https://smallstep.com/docs/step-ca/configuration
  look at nixos/tests/step-ca.nix for inspiration
*/
{
  pkgs,
  config,
  rootCaPath,
  ...
}:
{

  enable = true;
  port = 8443; # there is no default :s
  address = "localhost";
  intermediatePasswordFile = "/run/secrets/step-ca-certificate-password";
  # goes to ca.json  see
  # https://smallstep.com/docs/step-ca/configuration
  # settings = builtins.fromJSON (builtins.readFile ../ca.json);
  settings = {
    # dnsNames = [ "caserver" ];
    root = "${rootCaPath}";
    crt = "${../intermediate_ca.crt}";
    # cl'est la cle de l'intermediate
    key = config.sops.secrets."step-ca-intermediate-key".path;
    db = {
      type = "badger";
      dataSource = "/var/lib/step-ca/db";
    };
    authority = {
      claims = {
        minTLSCertDuration = "5m";
        defaultTLSCertDuration = "2160h"; # 90 days
        maxTLSCertDuration = "2160h";
      };

      provisioners = [
        {
          type = "ACME";
          name = "acme";
        }
      ];
    };
  };

}
