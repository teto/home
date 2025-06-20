{
  config,
  pkgs,
  lib,
  secrets,
  flakeSelf,
  withSecrets,
  ...
}:
let
  defaultSupportedFeatures = [
    "nixos-test"
    "big-parallel"
    "i686-linux" # testing
    "i686" # testing
    "kvm"
  ];
in
{
  programs.bash = lib.optionalAttrs (lib.trace "nova bash.nix" withSecrets) {

    sessionVariables =
      let
        prod-runners = 
            builtins.fromJSON (
            # TODO fetch it from doctor ?
            # builtins.readFile "${flakeSelf.inputs.nova-ci}/configs/prod/runners-generated.json"
            builtins.readFile "${flakeSelf.inputs.nova-doctor}/nix/hm/ci-runners/runners-generated.json"
          );

        mkKey =
          name:
          # TODO normalize name toShellVar ?
          lib.toUpper ("NOVA_" + lib.replaceStrings [ "-" ] [ "_" ] name);

        # generates a { NOVA_XXX = string } attrset that contains paths toward remote builders
        remoteBuilders = lib.listToAttrs (
          map
            (
              attr:
              # attrs should only contain
              # So seems like there is no way to fix those
              lib.nameValuePair (mkKey attr.runnerName) (
                pkgs.tetoLib.mkRemoteBuilderDesc (
                  attr
                  // {
                    sshUser = secrets.nova.runners.ovh1.userName;
                    sshKey = secrets.nova.runners.ovh1.sshKey;
                    system = "x86_64-linux,i686-linux";
                    maxJobs = 10;
                    speedFactor = 2;
                    supportedFeatures = defaultSupportedFeatures;
                    # A machine will only be used to build a derivation if all of the machine’s required features appear in the derivation’s requiredSystemFeatures attribute.
                    mandatoryFeatures = [ ];
                    # TODO to fill up
                    publicHostKey = null;
                    hostName = attr.hostname;
                  }
                )
              )
            )
            # TODO we should expose the resulting nix expressions directly
            prod-runners
        );
      in
      {
        # TODO pass the correct port, how to do that ? need ssh_config support
        # NOVA_RUNNER1 = mkRemoteBuilderDesc secrets.nova-runner-1;
        # NOVA_CACHE_DEV = secrets.nova.novaNixCache.dev;
        # NOVA_CACHE_PROD = secrets.nova.novaNixCache.prod;
        CI_REGISTRY_IMAGE = "https://registry.novadiscovery.net";
        HUSKY = 0; # To disable HUSKY
        # wayland variables
        # CDPATH = "$CDPATH:$HOME/nova";
      }
      // remoteBuilders;

  };
}
