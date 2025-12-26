{
  config,
  lib,
  ...
}:
{
  imports = [
  ];

  # This will add secrets.yml to the nix store
  # You can avoid this by adding a string to the full path instead, i.e.
  # todo use homeDir of users.teto ?
  sops.defaultSopsFile = "${config.home-manager.users.teto.home.homeDirectory}/neotokyo-secrets.yaml";

  # to avoid the 'secrets.yaml' is not in the Nix store.
  sops.validateSopsFiles = false;

  # Paths to ssh keys added as age keys during sops description.
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # sops.age.keyFile = "/home/teto/home/secrets/age.key";

  # %r gets replaced with a runtime directory, use %% to specify a '%'
  # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
  # DARWIN_USER_TEMP_DIR) on darwin.
  # path = "%r/test.txt";

  sops.secrets =
    # check depending on services.restic. instead
    # lib.optionalAttrs config.services.postgresqlBackup.enable
    {
      "restic/backblaze_backup_immich_credentials" = {
        mode = "440";
        # path = "%r/github_token";
        owner = config.users.users.teto.name;
        group = config.users.users.teto.group;
      };

      "restic/endpoint" = {
        mode = "440";
        # path = "%r/github_token";
        owner = config.users.users.teto.name;
        group = config.users.users.teto.group;
      };

      "restic/backup_immich_repo_password" = {
        mode = "440";
        owner = config.users.users.teto.name;
        group = config.users.users.teto.group;
      };

      "fastmail_msmtp" = {
        mode = "400";
        owner = config.users.users.teto.name;
        group = config.users.users.teto.group;
      };
    }
    // lib.optionalAttrs config.services.buildbot-master.enable {
      "buildbot-client-secret" = {
        mode = "440";
        owner = config.users.users.buildbot.name;
        group = config.users.users.teto.group;
      };
    };

}
