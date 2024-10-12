{ dotfilesPath, ... }:
{
  imports = [
    ../../../nixos/profiles/immich.nix
  ];
  services.immich = {
    enable = true;
    # host = ""; # all interfaces (example from module option) breaks with nginx

    machine-learning = {
      enable = true;
    };
    # secretsFile
    openFirewall = true;

    # https://immich.app/docs/install/environment-variables/
    environment = {
      IMMICH_LOG_LEVEL = "verbose";
    };

    # merged into environment
    # secretsFile = "/run/secrets/immich";
  };

}
