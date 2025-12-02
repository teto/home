{
  lib,
  secrets,
  osConfig,
  withSecrets,
  flakeSelf,
  secretsFolder,
  ...
}:
let

  #
  hostsConfigs =
    let
      # mcfg of type "nixosConfiguration"
      genSshConfig =
        name: value:
        let
          mcfg = value;
          sshCfg = mcfg.config.services.openssh;
        in
        builtins.trace "SSH config for ${name}" (
          lib.optionalAttrs sshCfg.enable
            # lib.warn if "teto" is not in users.users
            (
              {
                match = "host ${mcfg.config.networking.hostName}";
                # assumption ? or check/warn it has it ?
                user = "teto";
                identityFile = "${secretsFolder}/ssh/id_rsa";
                identitiesOnly = true;
                extraOptions = {
                  AddKeysToAgent = "yes";
                  HostName = "${mcfg.config.networking.domain}";
                };
              }
            )
        );
    in
    lib.mapAttrs genSshConfig flakeSelf.nixosConfigurations;
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

      neotokyo-teto = {
        match = "user teto host ${secrets.jakku.hostname}";
        hostname = secrets.jakku.hostname;
        user = "teto";

        addKeysToAgent = "yes";
        # le port depend du service
        port = secrets.jakku.sshPort;
        identityFile = "${secretsFolder}/ssh/id_rsa";
        identitiesOnly = true;
        serverAliveCountMax = 3;
        # sendEnv
        extraOptions = {

        };
      };

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

      router = {
        # checkHostIP
        identityFile = "${secretsFolder}/ssh/id_rsa";
        user = "teto";
        # host = "router";
        addKeysToAgent = "yes";
        hostname = secrets.router.hostname;
        identitiesOnly = true;
        # experimental
        # https://github.com/nix-community/home-manager/pull/2992
        match = "host router";
        # port = 12666;
        # RemoteCommand
        # SendEnv LANG LC_*
      };

      router-lan = {
        addKeysToAgent = "yes";
        # checkHostIP
        identityFile = "${secretsFolder}/ssh/id_rsa";
        user = "teto";
        # host = "router";
        hostname = "10.0.0.1";
        identitiesOnly = true;
        match = "host router-lan";
        port = 12666;
      };

    });

  includes = [
    # break under haumea
    # "${config.xdg.configHome}/ssh/config"
    # so we hardcoded it
    "/home/teto/.config/ssh/config"
  ];

  # TODO parts of this should be accessible from
  # extraConfig = ''
  #   Include
  #   # TODO remove when doctor's home-manager is ok
  #   Include ${config.xdg.configHome}/nova/jinkompute/ssh_config
  # '';
}
