{ config, lib, pkgs,  ... }:
{

  services.nextcloud = {
    enable = true;
    inherit hostName;
    nginx.enable = true;
    https = true;
    autoconfig = {
      dbtype = "pgsql";
      dbname = "nextcloud";
      dbuser = "nextcloud";
      dbhost = "localhost";
      inherit (secrets.services.nextcloud.autoconfig) dbpass;
      adminlogin = "nextcloud-admin";
      adminpassFile = "/run/keys/nextcloud-adminpass-file";
    };
    maxUploadSize = "512M";
    home = "/data/var/lib/nextcloud";
  };
}
