{
  flakeSelf,
  lib,
  pkgs,
  withSecrets,
  secrets,
  ...
}:
let
  hostsConfigs = lib.mapAttrs lib.genSshClientConfig flakeSelf.nixosConfigurations;
in

{
  # to generate ssh config file for the nix builder
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    # todo add publickey for my server

    matchBlocks = hostsConfigs;

    # KnownHostsCommand
    # GlobalKnownHostfiles Specifies one or more files to use for the global host key database, separated by whitespace. The default is /etc/ssh/ssh_known_hosts, /etc/ssh/ssh_known_hosts2.
    extraOptionOverrides = lib.optionalAttrs withSecrets {
      # TODO i might as well have saved the whole ssh-keyscan ?!
      # GlobalKnownHostfiles = pkgs.writeText "global_known_host_files" ''
      #   ${flakeSelf.nixosConfigurations.neotokyo.config.networking.domain} ${builtins.readFile ../../../../../hosts/neotokyo/host_key.pub}
      #   '';

    };

  };

  imports = [
    flakeSelf.homeModules.neovim
  ];
}
