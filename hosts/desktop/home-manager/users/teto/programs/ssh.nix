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

  programs.ssh = {

    # mkForce needed to override doctor's config
    enable = lib.mkForce true;
    # When enabled, a private key that is used during authentication will be added to ssh-agent if it is running (with confirmation enabled if set to ‘confirm’). The argument must be ‘no’ (the default), ‘yes’, ‘confirm’ (optionally followed by a time
    #           interval), ‘ask’ or a time interval (e.g. ‘1h’).

    addKeysToAgent = "yes";

    # can I have it per target ?
    # controlPath = "";
    matchBlocks = lib.optionalAttrs withSecrets {

      gitlab = {
        match = "host=gitlab.com";
        user = "mattator";
        identityFile = "${secretsFolder}/ssh/gitlab";
        identitiesOnly = true;
      };

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
        # host = "router";
        hostname = secrets.router.hostname;
        identitiesOnly = true;
        # experimental
        # https://github.com/nix-community/home-manager/pull/2992
        match = "host=router";
        port = 12666;
        # RemoteCommand
        # SendEnv LANG LC_*
      };

      router-lan = {
        # checkHostIP
        identityFile = "${secretsFolder}/ssh/id_rsa";
        user = "teto";
        # host = "router";
        hostname = "10.0.0.1";
        identitiesOnly = true;
        # experimental
        # https://github.com/nix-community/home-manager/pull/2992
        match = "host=router-lan";
        port = 12666;
      };

    };

    includes = [
      "${config.xdg.configHome}/ssh/config"
    ];

    # TODO parts of this should be accessible from 
    # extraConfig = ''
    #   Include 
    #   # TODO remove when doctor's home-manager is ok
    #   Include ${config.xdg.configHome}/nova/jinkompute/ssh_config
    # '';
  };
}
