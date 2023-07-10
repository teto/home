# TODO this should be fetched from the runners themselves !
{ config, pkgs, lib
, secrets
, flakeInputs
, ...
}:
let
  # secrets = import ../../../nixpkgs/secrets.nix;
   sshLib = import ../../../nixpkgs/lib/ssh.nix { inherit secrets flakeInputs; };

in
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
             (sshLib.mkSshMatchBlock attr)
            )
            # TODO we should expose the resulting nix expressions directly
             prod-runners);
      in
      remoteBuilders;
    # {
     # prod-runners = builtins.fromJSON (builtins.readFile "${flakeInputs.nova-ci}/configs/prod/runners-generated.json");
     # TODO generate those / map
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
      #   extraOptions.userKnownHostsFile = "${flakeInputs.nova-ci}/configs/prod/ssh_known_hosts";
		# port = 12666;
      # };
    # } // remoteBuilders;
  };
}
