/*
  https://wiki.nixos.org/wiki/WireGuard
  sudo networkctl up wg0
*/
{
  config,
  lib,
  # pkgs,
  secretsFolder,
  withSecrets,
  ...
}:
lib.optionalAttrs withSecrets {
  # replaced by tetos.wireguard
  #   # enable = false;
  #   interfaces = {
  #     # "wg0" is the network interface name. You can name the interface arbitrarily.
  #     wg0 = lib.mkWireguardPeer {
  #       id = 2;
  #       # inherit (config.networking) hostName;
  #       privateKeyFile = "${secretsFolder}/wireguard/${config.networking.hostName}-wg.key";
  #       publicKey = "1uhd6iscyFt68twrVz+y4zvws5PzhpIuY4rrr4N/Ymk=";
  #     };
  #
  #   };
}
