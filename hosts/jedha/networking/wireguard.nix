/*
  https://wiki.nixos.org/wiki/WireGuard
  sudo networkctl up wg0
  https://github.com/PaulGrandperrin/nix-systems/blob/main/nixosModules/shared/wireguard.nix
*/

{
  config,
  lib,
  # pkgs,
  secretsFolder,
  # secrets,
  withSecrets ? false,
  ...
}:
{

  # enable = false;

  # interfaces.wg = {
  #   ips = [ "10.100.0.2/24" ];
  # };

  interfaces = lib.optionalAttrs withSecrets {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = lib.mkWireguardPeer {

      id = 3;
      privateKeyFile = "${secretsFolder}/wireguard/${config.networking.hostName}-wg.key";
    };
  };
}
