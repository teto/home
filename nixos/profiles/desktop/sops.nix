{
  config,
  lib,
  secretsFolder,
  withSecrets,
  ...
}:
{

  # This will add secrets.yml to the nix store
  # You can avoid this by adding a string to the full path instead, i.e.
  defaultSopsFile = "${secretsFolder}/desktop-secrets.yaml";
  # to avoid the 'secrets.yaml' is not in the Nix store.
  validateSopsFiles = false;

  # This is using an age key that is expected to already be in the filesystem
  age.keyFile = "${secretsFolder}/age.key";
  secrets = lib.optionalAttrs withSecrets {
    # By default secrets are owned by root:root. Furthermore the parent directory /run/secrets is only owned by root and the keys group has read access to it:
    # This is the actual specification of the secrets.
    github_token = {
      mode = "400";
      owner = config.users.users.teto.name;
      group = config.users.users.teto.group;

    };

    "gitlab/apiToken" = {
      mode = "400";
      owner = config.users.users.teto.name;
      group = config.users.users.teto.group;

    };

    nix_extra_config = {
      mode = "400";
      owner = config.users.users.teto.name;
      group = config.users.users.teto.group;
    };
  };

}
