{
  config,
  lib,
  pkgs,
  ...
}:
{
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

  # huggingfaceToken = {
  #   mode = "0440";
  #   # TODO only readable by gitlab
  #   owner = config.users.users.teto.name;
  #   group = config.users.users.nobody.group;
  # };

  nix_extra_config = {
    mode = "400";
    owner = config.users.users.teto.name;
    group = config.users.users.teto.group;
  };
}
