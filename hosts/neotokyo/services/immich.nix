{
  secrets,
  pkgs,
  lib,
  ...
}:
{
  services.immich = {
    enable = true;
    # host = ""; # all interfaces (example from module option) breaks with nginx

    # The group immich should run as.
    group = "immich";

    # database = {
    #
    #   enableVectorChord = false;
    #   enableVectors = false;
    #
    # };

    machine-learning = {
      # enable = lib.mkForce true;
      enable = false;
    };

    # secretsFile
    # TODO remove once it runs behind vpn
    openFirewall = true;

    # "IMMICH_MEDIA_LOCATION=/var/lib/immich"
    # https://immich.app/docs/install/environment-variables/
    environment = {
      IMMICH_LOG_LEVEL = "verbose";
    };

    # merged into environment
    # secretsFile = "/run/secrets/immich";
  };

  # TODO see nginx config for the reset

  systemd.services.immich-server.serviceConfig = {
    # we override the default 0077 such that the backup job can read the files
    UMask = "0027";
  };

}
