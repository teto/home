{ config, lib, pkgs, secrets, ... }:
let
  # secrets = import ../nixpkgs/secrets.nix;

  # used to setup sops at the bottom of the file
  nextcloudAdminPasswordSopsPath = "nextcloud/adminPassword";
in
{

  services.nextcloud = {
    enable = true;

    # Use HTTPS for links
    # https = true;

    # package = pkgs.nextcloud27;
    # New option since NixOS 23.05
    configureRedis = true;
    # caching.apcu = false;

    config = {
      # we choose postgres because it's faster
      dbtype = "pgsql";
      # Further forces Nextcloud to use HTTPS
      # loaded via sops 
      adminpassFile = "/run/secrets/${nextcloudAdminPasswordSopsPath}";
      # TODO change it
      # adminUser = "root";
      # dbpassFile = 

      # we can use an s3 account
      # objectstore.s3.enable
    };
    maxUploadSize = "512M";
    # disable imageMagick for security reasons
    enableImagemagick = true;
    autoUpdateApps.enable = true;

    extraAppsEnable = true;
    extraApps = with config.services.nextcloud.package.packages.apps; {
     # inherit news; # removed 'cos gives a wrong error
     inherit contacts;
	  # mail extension can't be download :s 
      # example of how to get a more recent version
      # contacts = pkgs.fetchNextcloudApp rec {
      #   url = "https://github.com/nextcloud-releases/contacts/releases/download/v4.2.2/contacts-v4.2.2.tar.gz";
      #   sha256 = "sha256-eTc51pkg3OdHJB7X4/hD39Ce+9vKzw1nlJ7BhPOzdy0=";
      # };
    };
  # to be able to send mails from the admin panel
  # Test mails can be send via administration interface in the menu section "Basic settings". 
    settings = {
     mail_smtpmode = "sendmail";
     mail_sendmailmode = "pipe";
     overwriteProtocol = "https";
     logLevel = 0;

   };
  };


  networking.firewall.allowedTCPPorts = [ 80 443 ];


  sops.secrets.${nextcloudAdminPasswordSopsPath} = {
    mode = "0440";
    owner = config.users.users.nextcloud.name;
    group = config.users.users.nextcloud.group;
  };



  # create some errors on deploy
  # services.nginx.virtualHosts = { 
  #   # "cloud.acelpb.com" = {... }
  #   "${secrets.gitolite_server.hostname}" = {
  #     forceSSL = false;
  #   };
  # };
}
