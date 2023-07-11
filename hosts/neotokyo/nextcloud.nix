{ config, secrets, lib, pkgs, ... }:
{

  imports = [
     ../../nixos/profiles/nextcloud.nix
  ];

  services.nextcloud = {
   hostName = secrets.jakku.hostname;
    https = false;

    # New option since NixOS 23.05
    configureRedis = true;
    # caching.apcu = false;
    extraAppsEnable = lib.mkForce false;

  };

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

}
