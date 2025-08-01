{
  config,
  secrets,
  lib,
  pkgs,
  flakeSelf,
  ...
}:
{

  imports = [
    flakeSelf.nixosModules.nextcloud
    ../../../nixos/profiles/nextcloud.nix
  ];

  services.nextcloud = {
    enable = true;

    # TODO disable ?
    # previewGenerator = true;
    #       description = "FQDN for the nextcloud instance.";
    hostName = "nextcloud.${secrets.jakku.hostname}";
    # true ?
    https = false;
    package = pkgs.nextcloud31;

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
    # New option since NixOS 23.05
    caching = {
      apcu = true;
      redis = true;
      memcached = false;
    };
    # caching.redis = true;

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
      # Further forces Nextcloud to use HTTPS, useful when behind proxy
      overwriteprotocol = "https";
    };

    extraApps = with config.services.nextcloud.package.packages.apps; {
      # inherit news; # removed 'cos gives a wrong error
      inherit
        memories
        previewgenerator
        # maps
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
      export OC_PASS="$(cat /run/secrets/nextcloud/tetoPassword)"
      nextcloud-occ user:add --password-from-env teto
      ${config.services.nextcloud.occ}/bin/nextcloud-occ user:setting teto settings email "${secrets.users.teto.email}"
    '';
    # ${config.services.nextcloud.occ}/bin/nextcloud-occ user:add --password-from-env user2
    # ${config.services.nextcloud.occ}/bin/nextcloud-occ user:setting user2 settings email "user2@localhost"
    # ${config.services.nextcloud.occ}/bin/nextcloud-occ user:setting admin settings email "admin@localhost"
    serviceConfig = {
      Type = "oneshot";
      User = "nextcloud";
    };
    # DONT run it automatically
    # after = [ "nextcloud-setup.service" ];

    # see https://discourse.nixos.org/t/disable-a-systemd-service-while-having-it-in-nixoss-conf/12732
    wantedBy = lib.mkForce [ ];
    # "multi-user.target"
    # ];
  };

  # security.acme.
  # https://nixos.org/manual/nixos/stable/index.html#module-security-acme
  # TODO remove it uses defaults from nginx.nix
  # security.acme = {
  #   acceptTerms = true;
  #   # defaults.email = secrets.users.teto.email;
  # };

  # create some errors on deploy
  # for now we generate one certificate per virtual host
  # https://discourse.nixos.org/t/nixos-nginx-acme-ssl-certificates-for-multiple-domains/19608/2
  services.nginx = {

    # ceeformat is unknown ?
    virtualHosts = {

      # see https://nixos.wiki/wiki/Nextcloud
      # extends the already configured by the nixos module nginx
      # https://betterstack.com/community/questions/what-is-the-difference-between-host-http-host-server-name-variable-nginx/
      # server_name is  typically used to match the server block in the Nginx configuration based on the incoming request.
      "nextcloud.${secrets.jakku.hostname}" = {
        forceSSL = true;

        # proxyWebsockets = true
        # https://nixos.org/manual/nixos/stable/index.html#module-security-acme
        enableACME = true;
        # enableReload = true; # reloads service when config changes !

        # listen = [ 80 ];
        # listen = [ { addr = "127.0.0.1"; port = 80; }];
        # locations."/" = {
        #   proxyPass = "http://localhost:8080"; # Assuming service 1 runs on localhost:8080
        # };
      };

    };
  };

  environment.systemPackages = [
    config.services.nextcloud.occ
    # inherit (cfg) datadir occ;

  ];

  # This is using an age key that is expected to already be in the filesystem
  # sops.age.keyFile = "/home/teto/.config/sops/age/keys.txt";
  sops.secrets."nextcloud/tetoPassword" = lib.mkIf config.services.nextcloud.enable {
    mode = "0440";
    # TODO only readable by gitlab
    owner = config.users.users.nextcloud.name;
    group = config.users.users.nextcloud.group;
  };

}
