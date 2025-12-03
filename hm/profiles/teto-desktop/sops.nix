{
  secretsFolder,
  withSecrets,
  lib,
}:
lib.optionalAttrs withSecrets {
  # SECRETS appear in ~/.config/sops-nix/secrets/*

  # This will add secrets.yml to the nix store
  # You can avoid this by adding a string to the full path instead, i.e.
  defaultSopsFile = "${secretsFolder}/desktop-secrets.yaml";
  validateSopsFiles = false;

  # This is using an age key that is expected to already be in the filesystem
  # sops.age.keyFile = "secrets/age.key";
  age.keyFile = "${secretsFolder}/age.key";
  # It's also possible to use a ssh key, but only when it has no password:
  #age.sshKeyPaths = [ "/home/user/path-to-ssh-key" ];

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

  # removed from secrets
  # secrets."OPENAI_API_KEY" = {
  #   # Key used to lookup in the sops file.
  #   key = "OPENAI_API_KEY_NOVA";
  #   mode = "400";
  # };

  secrets."claude_api_key" = {
    mode = "400";
  };

  secrets."gemini_matt_key" = {
    mode = "400";
  };

  secrets.huggingfaceToken = {
    mode = "0440";
    # TODO only readable by gitlab
    # owner = config.users.users.teto.name;
    # group = config.users.users.nobody.group;
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

  secrets.nix_extra_config = {
    mode = "400";
    # owner = config.users.users.teto.name;
    # group = config.users.users.teto.group;
  };

}
