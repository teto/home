{ config, secrets, lib, pkgs, ... }:
{

  imports = [
     ../../nixos/profiles/nextcloud.nix
  ];

  services.nextcloud = {
   hostName = secrets.jakku.hostname;
   https = false;

    # New option since NixOS 23.05
    caching = {
      apcu = false;
      redis = true;
      memcached = false;
    };
    # caching.redis = true;

    # use default redis config for small servers
    configureRedis = true;
    extraAppsEnable = lib.mkForce false;

    database.createLocally = true;

    config = {
      # we choose postgres because it's faster
      dbtype = "pgsql";

      # Further forces Nextcloud to use HTTPS
      # overwriteProtocol = "https";
    };

  };

  # services.redis.servers."nextcloud".enable = true;
  # services.redis.servers."nextcloud".port = 6379;

  # Creating Nextcloud users and configure mail adresses
  # disabling since it fails after first time
  # systemd.services.nextcloud-add-user = {
  # # --password-from-env  looks for the password in OC_PASS
  #   environment = {
  #     # OC_PASS = "${confFile}";
  #   };
  #   path = [
  #    # pkgs.which pkgs.procps

  #    config.services.nextcloud.occ
  #   ];
  #   # TODO check if necessary
  #   # preStart = ''

  #   # ${config.services.nextcloud.occ}/bin/
  #   script = ''
  #     export OC_PASS="$(cat /run/secrets/nextcloud/tetoPassword)"
  #     nextcloud-occ user:add --password-from-env teto
  #     ${config.services.nextcloud.occ}/bin/nextcloud-occ user:setting teto settings email "${secrets.users.teto.email}"
  #   '';
  #     # ${config.services.nextcloud.occ}/bin/nextcloud-occ user:add --password-from-env user2
  #     # ${config.services.nextcloud.occ}/bin/nextcloud-occ user:setting user2 settings email "user2@localhost"
  #     # ${config.services.nextcloud.occ}/bin/nextcloud-occ user:setting admin settings email "admin@localhost"
  #   serviceConfig = {
  #     Type = "oneshot";
  #     User= "nextcloud";
  #   };
  #   after = [ "nextcloud-setup.service" ];
  #   wantedBy = [ "multi-user.target" ];
  # };

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
