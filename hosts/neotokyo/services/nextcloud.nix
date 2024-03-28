{ config, secrets, lib, pkgs, ... }:
{

  imports = [
     ../../../nixos/modules/nextcloud.nix
     ../../../nixos/profiles/nextcloud.nix
  ];

  services.nextcloud = {
   enable = true;
   previewGenerator = true;
   hostName = secrets.jakku.hostname;
   https = false;
   package = pkgs.nextcloud28;

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

    settings =  {
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
      User= "nextcloud";
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
  security.acme = {
   acceptTerms = true;
   defaults.email = secrets.users.teto.email;
  };

  # create some errors on deploy
  services.nginx.virtualHosts = { 
    # "cloud.acelpb.com" = {... }
    # see https://nixos.wiki/wiki/Nextcloud
    "${secrets.jakku.hostname}" = {
      forceSSL = true;
      # https://nixos.org/manual/nixos/stable/index.html#module-security-acme
      enableACME = true;
      # enableReload = true; # reloads service when config changes !
    };
  };

  # This is using an age key that is expected to already be in the filesystem
  # sops.age.keyFile = "/home/teto/.config/sops/age/keys.txt";
  sops.secrets."nextcloud/tetoPassword" = {
    mode = "0440";
    # TODO only readable by gitlab
    owner = config.users.users.nextcloud.name;
    group = config.users.users.nextcloud.group;
  };

}
