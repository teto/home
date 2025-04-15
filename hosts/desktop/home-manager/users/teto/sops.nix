{
  secretsFolder,
  ...
}:
{

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
