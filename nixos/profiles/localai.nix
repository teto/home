{ config, lib, pkgs
, modulesPath
, ... }:
{
  # 
  imports = [
    "${modulesPath}/../../pkgs/by-name/lo/local-ai/module.nix"
  ];

  services.local-ai = {

    enable = false;
    port = 11111;
    # models = "/home/teto/models";
    
  };

  # testing with localai instead
  services.ollama = {
    enable = false;
  };


  # models-path
  # models
}
