{
  # config,
  # pkgs,
  lib,
  secrets,
  withSecrets,
  flakeSelf,
  secretsFolder,

  ...
}:
let
  mkSshMatchBlock = m: {
    user = secrets.nova.runners.nova-runner-1.sshUser;
    identityFile = secrets.nova.runners.nova-runner-1.sshKey;
    hostname = m.hostname;
    identitiesOnly = true;
    extraOptions = {
      # userKnownHostsFile = lib.mkForce "${flakeSelf.inputs.nova-ci}/configs/prod/ssh_known_hosts";

      # persist connections when logging in remote builders
      # controlmaster = "auto";
      # controlpath = "/tmp/ssh-%r@%h:%p";
    };

    # extraOptions.LocalCommand = "cd nixpkgs";
    # extraOptions.RemoteCommand = "cd nixpkgs";
    port = m.port;
    ##
    match = "host ${m.hostname},${m.runnerName}";
  };
in

{
  programs.ssh = {

    matchBlocks =
      let

        # TODO make this generic/available to all users
        prod-runners =  []
          # builtins.fromJSON (
          # # builtins.readFile "${flakeSelf.inputs.nova-ci}/configs/prod/runners-generated.json"
          # )
          ;

        remoteBuilders = lib.listToAttrs (
          map
            (
              attr:
              # attrs should only contain
              # So seems like there is no way to fix those
              lib.nameValuePair "${attr.runnerName}" (mkSshMatchBlock attr)
            )
            # TODO we should expose the resulting nix expressions directly
            prod-runners
        );
      in
      (lib.optionalAttrs (builtins.trace "ssh-config withSecrets for nova: ${toString withSecrets}" withSecrets) remoteBuilders)
      // {

        nova = {
          match = "host ${secrets.nova.gitlab.uri}";
          user = "matthieu.coudron"; # secrets.nova.gitlab.user;
          identityFile = "${secretsFolder}/ssh/nova_key";
        };
      };
  };
}
