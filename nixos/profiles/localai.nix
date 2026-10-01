{
  config,
  lib,
  pkgs,
  modulesPath,
  flakeSelf,
  ...
}:
{
  imports = [ 
  ];

  services.local-ai = {

    enable = false;
    port = 11111;
    # models = "/home/teto/models";

  };

}
