{
  config,
  lib,
  pkgs,
  ...
}:
{

  # /etc/ssh/ssh_known_hosts
  knownHosts = {

    neotokyo = {
      #   ${flakeSelf.nixosConfigurations.neotokyo.config.networking.domain} ${builtins.readFile ../../../../../hosts/neotokyo/host_key.pub}
      publicKey = builtins.readFile ../neotokyo_host_key.pub;
    };
  };

}
