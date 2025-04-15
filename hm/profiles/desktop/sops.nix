{
  secretsFolder,
  withSecrets,
}:
{
  # SECRETS appear in ~/.config/sops-nix/secrets/*

  # This will add secrets.yml to the nix store
  # You can avoid this by adding a string to the full path instead, i.e.
  defaultSopsFile = "${secretsFolder}/desktop-secrets.yaml";
  validateSopsFiles = false;

  # This is using an age key that is expected to already be in the filesystem
  # sops.age.keyFile = "secrets/age.key";
  age.keyFile = "${secretsFolder}/age.key";
  # By default secrets are owned by root:root. Furthermore the parent directory /run/secrets is only owned by root and the keys group has read access to it:
  # This is the actual specification of the secrets.
  secrets.github_token = {
    mode = "400";
    # %r gets replaced with a runtime directory, use %% to specify a '%'
    # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
    # DARWIN_USER_TEMP_DIR) on darwin.
    path = "%r/github_token";
    # owner = config.users.users.teto.name;
    # group = config.users.users.teto.group;
  };

  secrets."gitlab/apiToken" = {
    mode = "400";
    # owner = config.users.users.teto.name;
    # group = config.users.users.teto.group;

  };

  secrets."OPENAI_API_KEY" = {
    # Key used to lookup in the sops file.
    key = "OPENAI_API_KEY_NOVA";
    mode = "400";
  };

  # lab_config_file
  # https://github.com/zaquestion/lab
  secrets."lab/lab.toml" = {
    key = "lab_config_file";
    # path = "/home/teto/.config/lab/lab.toml";
    # alternatively one can use
    # LAB_CORE_TOKEN
    # LAB_CORE_HOST
    mode = "400";
    # owner = config.users.users.teto.name;
    # group = config.users.users.teto.group;
  };

}
