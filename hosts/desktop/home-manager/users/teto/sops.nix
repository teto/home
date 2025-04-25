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



}
