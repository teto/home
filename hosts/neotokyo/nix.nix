{ secretsFolder, config, ... }:
{

  settings = {

    secret-key-files = config.sops.secrets."nix-signing-key".path;

  };
}
