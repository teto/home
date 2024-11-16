{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
let
  acmeRoot = "/var/lib/acme/";
in
{

  security.acme = {
    acceptTerms = true;
    # defaults.email = "cert+admin@example.com";
    # "blog.${secrets.jakku.hostname}"

    /*
      we are trying to generate a multidomain certificate here,
      inspired by:
      - https://discourse.nixos.org/t/nixos-nginx-acme-ssl-certificates-for-multiple-domains/19608/3
    */
    certs."blog.${secrets.jakku.hostname}" = {
      # blog.${secrets.jakku.hostname}
      # webroot = acmeRoot;
      email = secrets.jakku.email;

      webroot = "/var/lib/acme/acme-challenge/";
      enableDebugLogs = true;
      group = "nginx";

      extraDomainNames = [
        # "blog.${secrets.jakku.hostname}"
        "www.${secrets.jakku.hostname}"
        "${secrets.jakku.hostname}"
        # "www.example.com"
      ];
      # https://discourse.nixos.org/t/setup-a-wildcard-certificate-with-acme-on-a-custom-domain-name-hosted-by-powerdns/15055/6
    };
    # certs."${secrets.jakku.hostname}" = {
    #   # ${secrets.jakku.hostname}
    #   webroot = "/var/lib/acme/";
    #   email = "cert+admin@example.de";
    #   group = "nginx";
    #   extraDomainNames = [ "www.example.de" ];
    # };
  };

  users.users.nginx.extraGroups = [ "acme" ];

  services.nginx = {
    # Enable status page reachable from localhost on http://127.0.0.1/nginx_status.
    statusPage = true;
    validateConfigFile = true;

    virtualHosts = {
      "blog.${secrets.jakku.hostname}" = {

        # default = true; # wtf does this do ?
        forceSSL = true;
        # https://nixos.org/manual/nixos/stable/index.html#module-security-acme
        # enableACME = true; # exclusive with useACMEHost
        useACMEHost = "blog.${secrets.jakku.hostname}";
        # All serverAliases will be added as extra domain names on the certificate.
        serverAliases = [
          # "blog.${secrets.jakku.hostname}" 
          "${secrets.jakku.hostname}"
          "www.${secrets.jakku.hostname}"
        ];
        # Directory for the ACME challenge, which is public. Don’t put certs or keys in here. Set to null to inherit from config.security.acme.
        # acmeRoot = "/var/lib/acme/challenges-de";

        # root /home/username/mysite/public/; #Absolute path to where your hugo site is
        # index index.html; # Hugo generates HTML
        # looking at https://gideonwolfe.com/posts/sysadmin/hugonginx/
        locations."/" = {
          extraConfig = ''
            try_files $uri $uri/ =404;
          '';
        };

        # I had to manually "chmod a+x /var/lib/gitolite"
        root = "/var/lib/gitolite/blog-generated";
      };

      "status.${secrets.jakku.hostname}" = {
        root = pkgs.runCommand "testdir" { } ''
          mkdir "$out"
          echo hello world > "$out/index.html"
        '';

      };
    };
  };
}
