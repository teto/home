{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.services.buildbot-nix.master.enable {
    "buildbot-client-secret" = {
      mode = "440";
      # path = "%r/github_token";
      owner = config.users.users.buildbot.name;
      group = config.users.users.buildbot.group;
    };
  } //
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

  nix_extra_config = {
    mode = "400";
    owner = config.users.users.teto.name;
    group = config.users.users.teto.group;
  };
}
