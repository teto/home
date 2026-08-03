{
  lib,
  secrets,
  config,
  withSecrets,
  flakeSelf,
  secretsFolder,
  ...
}:
let
  # TODO filter out the configurations ending with -no-secret ?
  hostsConfigs = lib.mapAttrs (_: val: lib.genSshClientConfig val) (
    lib.filterAttrs (name: _val: name != "neotokyo-no-secrets") flakeSelf.nixosConfigurations
  );
in
{

  # HashKnownHosts no
  # Match localnetwork

  enable = true;

  # When enabled, a private key that is used during authentication will be added to ssh-agent if it is running (with confirmation enabled if set to ‘confirm’). The argument must be ‘no’ (the default), ‘yes’, ‘confirm’ (optionally followed by a time
  #           interval), ‘ask’ or a time interval (e.g. ‘1h’).

  # avoids nasty warning
  enableDefaultConfig = false;

  # TODO generate those from the list of nixosConfigurations ?
  # can I have it per target ?
  # controlPath = "";
  # osConfig.
  settings =
    hostsConfigs
    # TODO we could customize them, with sendEnv for instance ?
    // (lib.optionalAttrs withSecrets {

      # we need to override this here so we can push to gitolite repos as simple users
      # use "gitolite-teto" as the user in the git remote
      gitolite-as-teto = (lib.genSshClientConfig flakeSelf.nixosConfigurations.neotokyo) // {
        header = "Match user gitolite host ${secrets.jakku.hostname}";
        user = "gitolite";
        identityFile = "${secretsFolder}/ssh/id_rsa";
        # port = secrets.jakku.sshPort;
      };

      # userKnownHostsFile
      github = {
        header = "match host github.com";

        user = "teto";
        identityFile = "${secretsFolder}/ssh/id_rsa";
        identitiesOnly = true;
        AddKeysToAgent = "yes";
      };

      gitlab = {
        match = "host gitlab.com";
        user = "mattator";
        identityFile = "${secretsFolder}/ssh/gitlab";
        identitiesOnly = true;
        AddKeysToAgent = "yes";
      };

      # this should be generated already ?
      jakku-teto = lib.genSshClientConfig flakeSelf.nixosConfigurations.neotokyo // {
        header = "Match user teto host ${secrets.jakku.hostname}";
        # match = "user teto host ${secrets.jakku.hostname}";
        hostname = secrets.jakku.hostname;
        user = "teto";
        addKeysToAgent = "yes";
        # le port depend du service
        identityFile = "${secretsFolder}/ssh/id_rsa";
        identitiesOnly = true;
        # identityAgent =
        serverAliveCountMax = 3;
        sendEnv = [
          "GITHUB_TOKEN"
          # seems like this might make deploy fail
          # "SOPS_AGE_SSH_PRIVATE_KEY_FILE"
        ];

        # RequestTTY force
        # RemoteCommand = "export GITHUB_TOKEN=$(cat ~/.config/sops-nix/secrets/github_token); exec $SHELL -l";
        # extraOptions = {
        # KnownHostsCommand is in addition to those listed in UserKnownHostsFile and GlobalKnownHostsFile
        # };
      };

      # match = "user teto host nix-community";
      # Match Tagged forceTMUX
      #   # Force start tmux automatically with a session named "RemoteSSH"
      #   # If that session already exist, connect to it instead of starting a new one
      #   RemoteCommand tmux new-session -A -s RemoteSSH
      #   RequestTTY yes
      "Match Tagged nix-builder" = {
        header = "Match Tagged nix-builder";
        RemoteCommand = "teto";
        sendEnv = [ "GITHUB_TOKEN" ];
      };

      "nix-community-teto" = {
        header = "Match user teto host nix-community";

        # https://nix-community.org/community-builders/
        # ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIElIQ54qAy7Dh63rBudYKdbzJHrrbrrMXLYl7Pkmk88H
        # match = "user teto host nix-community";
        hostname = "build-box.nix-community.org";
        user = "teto";
        addKeysToAgent = "yes";
        # le port depend du service
        # port = secrets.jakku.sshPort;
        identityFile = "${secretsFolder}/ssh/nix-community-builder";
        identitiesOnly = true;
        serverAliveCountMax = 3;
        sendEnv = [ "GITHUB_TOKEN" ];
        tag = "nix-builder";
      };

      # as a user we should be able to override the key
      # neotokyo = {
      #   header = "Match user gitolite host ${secrets.jakku.hostname}";
      #   # match =;
      #   hostname = secrets.jakku.hostname;
      #   # user = "gitolite";
      #   # le port depend du service
      #   port = secrets.jakku.sshPort;
      #   identityFile = "${secretsFolder}/ssh/neotokyo-gitolite";
      #   identitiesOnly = true;
      # };

    });

  includes = [
    "${config.xdg.configHome}/ssh/config"
  ];

  # GlobalKnownHostfiles Specifies one or more files to use for the global host key database, separated by whitespace. The default is /etc/ssh/ssh_known_hosts, /etc/ssh/ssh_known_hosts2.
  extraOptionOverrides = {

  };

}
