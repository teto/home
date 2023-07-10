{ config, secrets, lib, pkgs, ... }:
{

  imports = [
     ../../nixos/profiles/nextcloud.nix
  ];
  services.nextcloud.hostName = "localhost";

  # Creating Nextcloud users and configure mail adresses
  systemd.services.nextcloud-add-user = {
  # --password-from-env  looks for the password in OC_PASS
    script = ''
      export OC_PASS="test123"
      ${config.services.nextcloud.occ}/bin/nextcloud-occ user:add --password-from-env teto
      ${config.services.nextcloud.occ}/bin/nextcloud-occ user:setting teto settings email "${secrets.users.teto.email}"
    '';
      # ${config.services.nextcloud.occ}/bin/nextcloud-occ user:add --password-from-env user2
      # ${config.services.nextcloud.occ}/bin/nextcloud-occ user:setting user2 settings email "user2@localhost"
      # ${config.services.nextcloud.occ}/bin/nextcloud-occ user:setting admin settings email "admin@localhost"
    serviceConfig = {
      Type = "oneshot";
      User= "nextcloud";
    };
    after = [ "nextcloud-setup.service" ];
    wantedBy = [ "multi-user.target" ];
  };

}
