{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  services.local-ai = {

    enable = true;
    port = 11111;
    models = "/home/teto/models";

  };
}
