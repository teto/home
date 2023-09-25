# TODO this should be fetched from the runners themselves !
{ config, pkgs, lib
, secrets
, withSecrets
, flakeInputs
, ... }:
{
  imports = [
   ../../../hm/profiles/nova/ssh-config.nix

  ];

  programs.ssh = {

    enable = true;

    # can I have it per target ?
    # controlPath = "";
    matchBlocks = lib.optionalAttrs withSecrets {
      jakku = {
        host = secrets.jakku.hostname;
        user = "teto";
        # le port depend du service
        port = secrets.jakku.sshPort;
        identityFile = "~/.ssh/id_rsa";
      };

      router = {
        # checkHostIP
        identityFile = "~/.ssh/id_rsa";
        user = "teto";
        host = "router";
        hostname = secrets.router.hostname;
        identitiesOnly = true;
        # experimental
        # https://github.com/nix-community/home-manager/pull/2992
        # match = "ovh1";
		port = 12666;
      };

     };

    extraConfig = 
    ''
    Include "${config.xdg.configHome}/ssh/config"
    # TODO remove when doctor's home-manager is ok
    Include ${config.xdg.configHome}/nova/jinkompute/ssh_config
    '';
  };
}
