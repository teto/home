{
  secretsFolder,
  ...
}:
{
  # SECRETS appear in ~/.config/sops-nix/secrets/*

  # This will add secrets.yml to the nix store
  # You can avoid this by adding a string to the full path instead, i.e.
  sops.defaultSopsFile = "${secretsFolder}/desktop-secrets.yaml";
  sops.validateSopsFiles = false;

  # This is using an age key that is expected to already be in the filesystem
  # sops.age.keyFile = "secrets/age.key";
  sops.age.keyFile = "${secretsFolder}/age.key";

  # By default secrets are owned by root:root. Furthermore the parent directory /run/secrets is only owned by root and the keys group has read access to it:
  # This is the actual specification of the secrets.
  sops.secrets.github_token = {
    mode = "400";
    # %r gets replaced with a runtime directory, use %% to specify a '%'
    # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
    # DARWIN_USER_TEMP_DIR) on darwin.
    path = "%r/github_token";
    # owner = config.users.users.teto.name;
    # group = config.users.users.teto.group;
  };

  sops.secrets."restic/teto-bucket" = {
    mode = "0440";
    # TODO only readable by gitlab
    # owner = config.users.users.teto.name;
    # group = config.users.users.nobody.group;
  };

  # OPENAI_API_KEY_PERSO
  sops.secrets."OPENAI_API_KEY_NOVA" = {
    mode = "400";
  };

  sops.secrets.huggingfaceToken = {
    mode = "0440";
    # TODO only readable by gitlab
    # owner = config.users.users.teto.name;
    # group = config.users.users.nobody.group;
  };

  sops.secrets.nix_extra_config = {
    mode = "400";
    # owner = config.users.users.teto.name;
    # group = config.users.users.teto.group;
  };

}
