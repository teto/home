# config is visiblew at /var/www/nextcloud/config/config.php
{
  config,
  secrets,
  lib,
  pkgs,
  flakeSelf,
  ...
}:
let
  wgEndpoint = "10.100.0.1";
  nextcloudHostname = "nextcloud.vps";
in
{

  imports = [
    flakeSelf.nixosModules.nextcloud
    flakeSelf.nixosProfiles.nextcloud
  ];

  services.nextcloud = {
    enable = true;

    # 'hostName' is the name of the nginx virtualhost
    hostName = nextcloudHostname;

    # Trusted domains, from which the nextcloud installation will be accessible. You don’t need to add ‘services.nextcloud.hostname’ here.
    # trustedDomains = [ ];
    # trusted_proxies = [ ];
    # true ?
    https = false;

    package = pkgs.nextcloud34;

    # so I used to have
    # ✗ PHP opcache: The PHP OPcache module is not properly configured. OPcache is not working as it should, opcache_get_status() returns false, please check configuration.
    # The maximum number of OPcache keys is nearly exceeded. To assure that all scripts can be kept in the cache, it is recommended to apply "opcache.max_accelerated_files" to your PHP configuration with a value higher than "10000".
    # The OPcache buffer is nearly full. To assure that all scripts can be hold in cache, it is recommended to apply "opcache.memory_consumption" to your PHP configuration with a value higher than "128".
    # The OPcache interned strings buffer is nearly full. To assure that repeating strings can be effectively cached, it is recommended to apply "opcache.interned_strings_buffer" to your PHP configuration with a value higher than "8"..
    phpOptions = {

      # check https://www.php.net/manual/en/opcache.configuration.php#ini.opcache.max-accelerated-files
      # "opcache.fast_shutdown" = "1";
      "opcache.interned_strings_buffer" = "20";
      "opcache.max_accelerated_files" = "1000000";
      "opcache.memory_consumption" = "256";
      "opcache.revalidate_freq" = "1";
    };

    caching = {
      apcu = true;
      redis = true;
      memcached = false;
    };

    # use default redis config for small servers
    configureRedis = true;

    appstoreEnable = true;
    extraAppsEnable = lib.mkForce false;

    database.createLocally = true;

    config = {
      # we choose postgres because it's faster
      dbtype = "pgsql";
    };

    settings = {
      default_phone_region = "FR";
      # This internal vhost currently serves plain HTTP (https/forceSSL are disabled).
      # Keep generated asset and login URLs on the protocol nginx actually serves.
      overwriteprotocol = "http";
    };

    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit
        # memories # not supported
        previewgenerator
        # maps
        # news
        # calendar
        ;

    };

    # secretFile = "/run/secrets/nextcloudSecrets.json";
    #     Secret options which will be appended to Nextcloud’s config.php file (written as JSON, in the same form as the services.nextcloud.settings[1] option), for example ‘{"redis":{"password":"secret"}}’.

  };

  # services.redis.servers."nextcloud".enable = true;
  # services.redis.servers."nextcloud".port = 6379;

  # Creating Nextcloud users and configure mail adresses
  # disabling since it fails after first time
  # --password-from-env  looks for the password in OC_PASS
  # environment = { # OC_PASS = "${confFile}";
  # };
  systemd.services.nextcloud-add-user = {
    path = [ config.services.nextcloud.occ ];
    script = ''
      export OC_PASS="$(cat ${config.sops.secrets."nextcloud/tetoPassword".path})"
      nextcloud-occ user:add --password-from-env teto
      ${config.services.nextcloud.occ}/bin/nextcloud-occ user:setting teto settings email "${secrets.users.teto.email}"
    '';
    # ${config.services.nextcloud.occ}/bin/nextcloud-occ user:setting admin settings email "admin@localhost"
    serviceConfig = {
      Type = "oneshot";
      User = "nextcloud";
    };
    # DONT run it automatically
    # after = [ "nextcloud-setup.service" ];

    # see https://discourse.nixos.org/t/disable-a-systemd-service-while-having-it-in-nixoss-conf/12732
    wantedBy = lib.mkForce [ ];
  };

  # create some errors on deploy
  # for now we generate one certificate per virtual host
  # https://discourse.nixos.org/t/nixos-nginx-acme-ssl-certificates-for-multiple-domains/19608/2
  services.nginx = {

    # ceeformat is unknown ?
    virtualHosts = {

      # the n
      # extends the host already configured by the nixos module nginx
      "${nextcloudHostname}" = {
        forceSSL = false;

        # proxyWebsockets = true
        # https://nixos.org/manual/nixos/stable/index.html#module-security-acme
        # enable step-ca generated
        enableACME = true;
        # enableReload = true; # reloads service when config changes !

        listenAddresses = [
          wgEndpoint
        ];

        # listen = [ 80 ];
        # listen = [ { addr = "127.0.0.1"; port = 80; }];
        # locations."/" = {
        #   proxyPass = "http://localhost:8080"; # Assuming service 1 runs on localhost:8080
        # };
        #
        # extraConfig = ''
        #   allow 193.168.0.1/24;
        #   deny all;
        # '';
      };

    };
  };

  environment.systemPackages = [
    config.services.nextcloud.occ
    # inherit (cfg) datadir occ;
  ];
}
