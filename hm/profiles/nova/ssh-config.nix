{ config, pkgs, lib
, secrets 
, withSecrets 
, flakeInputs
, ... }:
let
  # sshLib = import ../../../nixpkgs/lib/ssh.nix { inherit secrets flakeInputs; };
  mkSshMatchBlock = m: {
    user = secrets.nova-gitlab-runner-1.userName;
    identityFile = secrets.nova-runner-1.sshKey;
    hostname = m.hostname;
    identitiesOnly = true;
    extraOptions.userKnownHostsFile = "${flakeInputs.nova-ci}/configs/prod/ssh_known_hosts";
    port = m.port;
    # 
    match = "host=${m.hostname},${m.runnerName}";
  };
in
# Host prod-sshuttle.k8s.jinko.ai
# IdentityFile ~/.ssh/nova_key

# Host novinfra.net
# User ubuntu
# IdentityFile ~/.ssh/nova_key

{
  programs.ssh = {

    enable = true;

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
             (mkSshMatchBlock attr)
            )
            # TODO we should expose the resulting nix expressions directly
             prod-runners);
    in
     lib.optionalAttrs withSecrets remoteBuilders // {

      nova = {
        host = "git.novadiscovery.net";
        user = "matthieu.coudron";
        identityFile = "~/.ssh/nova_key";
      };
    };
	  
  };
}

