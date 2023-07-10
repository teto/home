# TODO this should be fetched from the runners themselves !
{ config, pkgs, lib, secrets, 
flakeInputs,
... }:
let
  secrets = import ../../../nixpkgs/secrets.nix;
  sshLib = import ../../../nixpkgs/lib/ssh.nix { inherit secrets flakeInputs; };
in
{
  programs.ssh = {

    enable = true;

    # can I have it per target ?
    # controlPath = "";
    matchBlocks = let 
     # TODO make this generic/available to all users
     prod-runners = builtins.fromJSON (builtins.readFile "${flakeInputs.nova-ci}/configs/prod/runners-generated.json");

     remoteBuilders = lib.listToAttrs (
          map
            (attr:
            # attrs should only contain
            # So seems like there is no way to fix those
            # secrets.nova-runner-1.sshUser 
            lib.nameValuePair 
             "${attr.runnerName}"
             (sshLib.mkSshMatchBlock attr)
            )
            # TODO we should expose the resulting nix expressions directly
             prod-runners);

    in remoteBuilders // {
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

      nova = {
        host = "git.novadiscovery.net";
        user = "matthieu.coudron";
        identityFile = "~/.ssh/nova_key";
      };
	  
      # ovh1 = {
      #   # checkHostIP
      #   identityFile = "~/.ssh/nova_key";
      #   user = "matthieu.coudron";
      #   host = "ovh1";
      #   hostname = "ovh-hybrid-runner-1.devops.novadiscovery.net";
      #   identitiesOnly = true;
      #   # experimental
      #   # https://github.com/nix-community/home-manager/pull/2992
      #   # match = "ovh1";
		# port = 12666;
      # };
    };

    extraConfig = 
    ''
    Include "${config.xdg.configHome}/ssh/config"
    # TODO remove when doctor's home-manager is ok
    Include ${config.xdg.configHome}/nova/jinkompute/ssh_config
    '';
  };
}
