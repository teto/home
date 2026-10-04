{
  lib,
  # pkgs,
  secrets,
  flakeSelf,
  # , secretsFolder
  config,
  withSecrets ? false,
  ...
}:
lib.optionalAttrs (lib.debug.traceValFn (a: "SECRETS ? ${toString a}") withSecrets) {
  domain = secrets.jakku.domain;

}
// {

  _imports = [
    # flakeSelf.nixosProfiles.wireguard
  ];

  # TODO fetch from secrets
  hostName = "neotokyo";

  domain = "fr";
  # if withSecrets then secrets.jakku.domain else "toto";

  useNetworkd = true;
  # useDHCP = true;

  # without these overrides, seems like nginx selects wrong server
  extraHosts = lib.wireguard.vpnHosts;

  firewall = {
    enable = true;
    allowedUDPPorts = [
      51820 # wireguard
      # nope
      # config.networking.wireguard.interfaces.wg0.listenPort
    ];

    allowedTCPPorts = [
      # This is just a test to see if I can access directly via wireguard
      5000
    ];
  };

  nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "ens3";
    internalInterfaces = [ "wg0" ];
  };

  # https://wiki.nixos.org/wiki/WireGuard#Peer_setup
  wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg = (lib.mkWireguardPeer {
      id = 1;
      privateKeyFile = config.sops.secrets.wg-private-key.path;
    }) // {
      listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

    };

  };
}
