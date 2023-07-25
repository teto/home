{ config, secrets, flakeInputs, lib, pkgs, ... }:
{
  imports = [
     ../../nixos/profiles/nextcloud.nix
  ];
  services.nextcloud = { 
    hostName = "localhost";
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
      # services.postgresql
      # dbport = config.services.postgresql.port;
      dbport = 5555;
    # port = 5555;

      # Further forces Nextcloud to use HTTPS
      # overwriteProtocol = "https";
    };

    extraApps = with config.services.nextcloud.package.packages.apps; {
     # inherit news; # removed 'cos gives a wrong error
     inherit memories;
     inherit previewgenerator;
    };

  };


  # Creating Nextcloud users and configure mail adresses
  # systemd.services.nextcloud-add-user = {
  # # --password-from-env  looks for the password in OC_PASS
  #   script = ''
  #     export OC_PASS="test123"
  #     ${config.services.nextcloud.occ}/bin/nextcloud-occ user:add --password-from-env teto
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

}

