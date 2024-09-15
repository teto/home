# TODO this should be fetched from the runners themselves !
{
  config,
  pkgs,
  lib,
  secrets,
  withSecrets,
  secretsFolder,
  flakeInputs,
  ...
}:
{
  imports = [ ../../../../hm/profiles/nova/ssh-config.nix ];

  programs.ssh = {

    # mkForce needed to override doctor's config
    enable = lib.mkForce true;

    # can I have it per target ?
    # controlPath = "";
    matchBlocks = lib.optionalAttrs withSecrets {
      jakku = {
        host = secrets.jakku.hostname;
        user = "teto";
        # le port depend du service
        port = secrets.jakku.sshPort;
        identityFile = "${secretsFolder}/ssh/id_rsa";
        identitiesOnly = true;
        # port = 12666;
      };

      router = {
        # checkHostIP
        identityFile = "${secretsFolder}/ssh/id_rsa";
        user = "teto";
        host = "router";
        hostname = secrets.router.hostname;
        identitiesOnly = true;
        # experimental
        # https://github.com/nix-community/home-manager/pull/2992
        # match = "ovh1";
        port = 12666;
      };

      router-lan = {
        # checkHostIP
        identityFile = "${secretsFolder}/ssh/id_rsa";
        user = "teto";
        host = "router";
        hostname = "10.0.0.1";
        identitiesOnly = true;
        # experimental
        # https://github.com/nix-community/home-manager/pull/2992
        # match = "ovh1";
        port = 12666;
      };

    };

    # TODO parts of this should be accessible from 
    extraConfig = ''
      Include "${config.xdg.configHome}/ssh/config"
      # TODO remove when doctor's home-manager is ok
      Include ${config.xdg.configHome}/nova/jinkompute/ssh_config
    '';
  };
}
