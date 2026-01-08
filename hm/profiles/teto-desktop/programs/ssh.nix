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
  hostsConfigs = lib.mapAttrs lib.genSshClientConfig flakeSelf.nixosConfigurations;
in
{

  # HashKnownHosts no

  # mkForce needed to override doctor's config
  enable = true;

  # When enabled, a private key that is used during authentication will be added to ssh-agent if it is running (with confirmation enabled if set to ‘confirm’). The argument must be ‘no’ (the default), ‘yes’, ‘confirm’ (optionally followed by a time
  #           interval), ‘ask’ or a time interval (e.g. ‘1h’).

  # avoids nasty warning
  enableDefaultConfig = false;

  # TODO generate those from the list of nixosConfigurations ?
  # can I have it per target ?
  # controlPath = "";
  # osConfig.
  matchBlocks =
    hostsConfigs
    # TODO we could customize them, with sendEnv for instance ?
    // (lib.optionalAttrs withSecrets {

      # userKnownHostsFile
      github = {
        match = "host github.com";
        user = "teto";
        identityFile = "${secretsFolder}/ssh/id_rsa";
        identitiesOnly = true;
        extraOptions = {
          AddKeysToAgent = "yes";
        };
      };

      gitlab = {
        match = "host gitlab.com";
        user = "mattator";
        identityFile = "${secretsFolder}/ssh/gitlab";
        identitiesOnly = true;
        extraOptions = {
          AddKeysToAgent = "yes";
        };
      };

      # this should be generated already ?
      neotokyo-teto = {
        match = "user teto host ${secrets.jakku.hostname}";
        hostname = secrets.jakku.hostname;
        user = "teto";
        addKeysToAgent = "yes";
        # le port depend du service
        # port = secrets.jakku.sshPort;
        identityFile = "${secretsFolder}/ssh/id_rsa";
        identitiesOnly = true;
        # identityAgent =
        serverAliveCountMax = 3;
        sendEnv = [ "GITHUB_TOKEN" ];
        extraOptions = {
          # KnownHostsCommand is in addition to those listed in UserKnownHostsFile and GlobalKnownHostsFile

        };
      };

      nix-community-builder = {

        # https://nix-community.org/community-builders/
        # ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIElIQ54qAy7Dh63rBudYKdbzJHrrbrrMXLYl7Pkmk88H
        match = "user teto host nix-community";
        hostname = "build-box.nix-community.org";
        user = "teto";
        addKeysToAgent = "yes";
        # le port depend du service
        # port = secrets.jakku.sshPort;
        identityFile = "${secretsFolder}/ssh/id_rsa";
        identitiesOnly = true;
        serverAliveCountMax = 3;
        sendEnv = [ "GITHUB_TOKEN" ];
      };

      # as a user we should be able to override the key
      neotokyo-gitolite-admin = {
        match = "user gitolite host ${secrets.jakku.hostname}";
        hostname = secrets.jakku.hostname;
        # user = "gitolite";
        # le port depend du service
        port = secrets.jakku.sshPort;
        identityFile = "${secretsFolder}/ssh/neotokyo-gitolite";
        identitiesOnly = true;
        # port = 12666;
      };

    });

  includes = [
    "${config.xdg.configHome}/ssh/config"
  ];

  # GlobalKnownHostfiles Specifies one or more files to use for the global host key database, separated by whitespace. The default is /etc/ssh/ssh_known_hosts, /etc/ssh/ssh_known_hosts2.
  extraOptionOverrides = {

  };

}
