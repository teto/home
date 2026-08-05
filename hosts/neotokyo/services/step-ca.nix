# I need some self-signed certificates for nextcloud client
# because I am using local TLDs, lets encrypt cant do
# https://gquetel.fr/misc/step-ca-nixos/
# https://smallstep.com/docs/step-ca/configuration
# look at nixos/tests/step-ca.nix for inspiration
{
  pkgs,
  config,
  rootCaPath,
  ...
}:
let
  test-certificates = pkgs.runCommandLocal "test-certificates" { } ''
    mkdir -p $out
    echo insecure-root-password > $out/root-password-file
    echo insecure-intermediate-password > $out/intermediate-password-file
    ${pkgs.step-cli}/bin/step certificate create "Example Root CA" $out/root_ca.crt $out/root_ca.key --password-file=$out/root-password-file --profile root-ca
    ${pkgs.step-cli}/bin/step certificate create "Example Intermediate CA 1" $out/intermediate_ca.crt $out/intermediate_ca.key --password-file=$out/intermediate-password-file --ca-password-file=$out/root-password-file --profile intermediate-ca --ca $out/root_ca.crt --ca-key $out/root_ca.key
  '';
  # security.pki.certificateFiles = [ "${test-certificates}/root_ca.crt" ];

in
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
