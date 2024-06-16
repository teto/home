{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  # imports = [
  #   "${modulesPath}/../../pkgs/by-name/lo/local-ai/module.nix"
  # ];

  services.local-ai = {

    enable = true;
    port = 11111;
    models = "/home/teto/models";

  };
}
