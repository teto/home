{ config, lib, pkgs, secrets, ... }:
let
  # secrets = import ../nixpkgs/secrets.nix;

  # used to setup sops at the bottom of the file
  nextcloudAdminPasswordSopsPath = "nextcloud/adminPassword";
in
{

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud27;

    # Use HTTPS for links
    https = true;

    # New option since NixOS 23.05
    configureRedis = true;
    caching.apcu = false;

    config = {
      # Further forces Nextcloud to use HTTPS
      overwriteProtocol = "https";
      # loaded via sops 
      adminpassFile = "/run/secrets/${nextcloudAdminPasswordSopsPath}";
      # TODO change it
      # adminUser = "root";
      # dbpassFile = 

      # we can use an s3 account
      # objectstore.s3.enable
    };
    maxUploadSize = "512M";
    logLevel = 0;
    enableBrokenCiphersForSSE = false;
    # increase security
    enableImagemagick = false;
    autoUpdateApps.enable = true;

    extraApps = with pkgs.nextcloud27Packages.apps; {
      inherit news contacts;
	  # mail extension can't be download :s 
      # example of how to get a more recent version
      # contacts = pkgs.fetchNextcloudApp rec {
      #   url = "https://github.com/nextcloud-releases/contacts/releases/download/v4.2.2/contacts-v4.2.2.tar.gz";
      #   sha256 = "sha256-eTc51pkg3OdHJB7X4/hD39Ce+9vKzw1nlJ7BhPOzdy0=";
      # };
    };
    extraAppsEnable = true;
  };

  # to be able to send mails from the admin panel
  # Test mails can be send via administration interface in the menu section "Basic settings". 
  # extraOptions = {
  #   mail_smtpmode = "sendmail";
  #   mail_sendmailmode = "pipe";
  # };
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
