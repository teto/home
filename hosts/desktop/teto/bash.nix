{ config, pkgs, lib, secrets, 
flakeInputs,
... }:
let
  secrets = import ../../../nixpkgs/secrets.nix;
  hmLib = pkgs.callPackage ../../../hm/lib.nix {}; 

in
{
  imports = [
   ../../../hm/profiles/shell.nix
   # ../../profiles/bash.nix
  ];

  programs.bash = {

    # goes to .profile
    sessionVariables = let 
     prod-runners = builtins.fromJSON (builtins.readFile "${flakeInputs.nova-ci}/configs/prod/runners-generated.json");
      defaultMandatoryFeatures = [];
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
      HISTTIMEFORMAT = "%d.%m.%y %T ";
      # CAREFUL 
      # HISTFILE="$XDG_CACHE_HOME/bash_history";
	  # TODO pass the correct port, how to do that ? need ssh_config support
      # NOVA_RUNNER1 = mkRemoteBuilderDesc secrets.nova-runner-1;
	  NOVA_CACHE_DEV  = secrets.novaNixCache.dev;
	  NOVA_CACHE_PROD = secrets.novaNixCache.prod;

	  # wayland variables

    } // remoteBuilders;

   };
 }
