{ config, secrets, lib, pkgs, ... }:
{
  # This is using an age key that is expected to already be in the filesystem
  # TODO use ssh key instead
  #  upload it with 
  # scp -F ssh_config "${SOPS_AGE_KEY_FILE}" hybrid-dev:/tmp/key.txt
  # then we move the file
  # ssh -F ssh_config hybrid-dev sudo mv /tmp/key.txt /var/lib/sops-nix/key.txt

  # sops.age.keyFile = "/home/teto/.config/sops/age/keys.txt";

  # TODO upload manually on server
  sops.age.keyFile = "/root/sops-key.txt";
  sops.defaultSopsFile = ./secrets.yaml;


  # This will generate a new key if the key specified above does not exist
  sops.age.generateKey = false;
  # sops.secrets."myservice/my_subdir/my_secret" = {};

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
