
{ config, pkgs, lib, secrets, 
flakeInputs,
... }:
let
   hmLib = pkgs.callPackage ../../../hm/lib.nix {}; 
in
{
  programs.bash = {

    # goes to .profile
    sessionVariables = let 
     prod-runners = builtins.fromJSON (builtins.readFile "${flakeInputs.nova-ci}/configs/prod/runners-generated.json");
      defaultMandatoryFeatures = [];

      # generates a { NOVA_XXX = string } attrset that contains paths toward remote builders
      remoteBuilders = lib.listToAttrs (
          map
            (attr:
            # attrs should only contain
            # So seems like there is no way to fix those
            # secrets.nova-runner-1.sshUser 
            lib.nameValuePair 
             (lib.toUpper "NOVA_${attr.runnerName}")
             (hmLib.mkRemoteBuilderDesc (attr // {
               sshUser = secrets.nova-gitlab-runner-1.userName;
               sshKey = secrets.nova-runner-1.sshKey;
               system = "x86_64-linux";
               maxJobs = 10;
               speedFactor = 2;
               supportedFeatures = [ ];
               mandatoryFeatures = defaultMandatoryFeatures;
               # TODO to fill up
               publicHostKey = null;
               hostName = attr.hostname;
              })
              )
            )
            # TODO we should expose the resulting nix expressions directly
             prod-runners);
    in {
	  # TODO pass the correct port, how to do that ? need ssh_config support
      # NOVA_RUNNER1 = mkRemoteBuilderDesc secrets.nova-runner-1;
	  NOVA_CACHE_DEV  = secrets.novaNixCache.dev;
	  NOVA_CACHE_PROD = secrets.novaNixCache.prod;

	  # wayland variables
    } // remoteBuilders;

 };
}
