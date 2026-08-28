{
  flakeSelf,
  secrets,
  system,
}:
{
  # This is the user that the profile will be deployed to (will use sudo if not the same as above).
  # If `sshUser` is specified, this will be the default (though it will _not_ default to your own username)
  sshUser = "teto";
  # user = "root";

  # Which sudo command to use. Must accept at least two arguments:
  # the user name to execute commands as and the rest is the command to execute
  # This will default to "sudo -u" if not specified anywhere.
  # sudo = "doas -u";

  # This is an optional list of arguments that will be passed to SSH.
  # sshOpts = [ "-p" "2121" ];

  # Fast connection to the node. If this is true, copy the whole closure instead of letting the node substitute.
  # This defaults to `false`
  fastConnection = false;

  # If the previous profile should be re-activated if activation fails.
  # This defaults to `true`
  autoRollback = true;

  # See the earlier section about Magic Rollback for more information.
  # This defaults to `true`
  magicRollback = true;

  # The path which deploy-rs will use for temporary files, this is currently only used by `magicRollback` to create an inotify watcher in for confirmations
  # If not specified, this will default to `/tmp`
  # (if `magicRollback` is in use, this _must_ be writable by `user`)
  # tempPath = "/home/someuser/.deploy-rs";

  # Build the derivation on the target system.
  # Will also fetch all external dependencies from the target system's substituters.
  # This default to `false`
  remoteBuild = false;

  # Timeout for profile activation.
  # This defaults to 240 seconds.
  activationTimeout = 600;

  # Timeout for profile activation confirmation.
  # This defaults to 30 seconds.
  confirmTimeout = 60;

  # for now
  # sshOpts = [ "-F" "ssh_config" ];
  # TODO go through all nixosConfigurations actually ?
  # If you require a signing key to push closures to your server, specify the path to it in the LOCAL_KEY environment variable.
  nodes =
    let
      # system = "x86_64-linux";
      genNode = attrs: {
        inherit (attrs) hostname;
        profiles.system = {
          # remoteBuild = false;
          user = "root";
          hostname = attrs.hostname;
          path =
            flakeSelf.inputs.deploy-rs.lib.${system}.activate.nixos
              flakeSelf.nixosConfigurations.${attrs.name};
        };
      };
    in
    {
      neptune-no-secrets =
        genNode {
          name = "neptune";
          # local-facing address neptune.local
          # hostname = "neptune.local"; # temporary
          hostname = "neptune.local"; # temporary
        }
        // {
          # while working around require-sigs issue
          # remoteBuild = true;

          sshOpts = [
            # "-p12666"
            #NIXOS_NO_CHECK=1
            # "-oSendEnv=NIXOS_NO_CHECK"
            "-p22"
            # "-F" "ssh_config"
            # "-i/home/teto/.ssh/id_rsa"
            # "-p${toString secrets.router.sshPort}"
          ];
          user = "root";
          sshUser = "teto";
        };

      # TODO router-local vs router-vpn
      router = genNode {
        name = "router";
        # local-facing address
        hostname = "router.local";
      };

      #
      jedha =
        genNode {
          name = "jedha";
          # fetch from secrets
          hostname = secrets.jedha.hostname;
        }
        // {
          # interactiveSudo = true;
          sshUser = "teto";
        };

      neotokyo =
        genNode {
          name = "neotokyo";
          hostname = secrets.jakku.hostname;
        }
        // {
          sshUser = "teto";
        };
    };
}
#         {
# }
