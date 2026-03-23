{ config, lib, ... }:
{
  hostName = "jedha";
  domain = "jedha.local"; # Define your hostname.

  networkmanager = {
    enable = true;
    unmanaged = [
      # we prefer to configure it with networkd
      "interface-name:enp11s0"
      #   "interface-name:r?-*"
      #   "interface-name:client-*"
      #   "interface-name:server-*"
    ];
  };

  useNetworkd = true;

  # hosts = [];

  # creates problem with buffalo check if it blocks requests or what
  # it is necessary to use dnssec though :(
  resolvconf.dnsExtensionMechanism = false;
  resolvconf.dnsSingleRequest = false;

  # osConfig.config.networking.firewall = lib.mkIf cfg.openFirewall {
  #   allowedTCPPorts = [ cfg.port ];
  # };

  firewall.allowedTCPPorts =
    lib.optional config.home-manager.users.teto.services.ollama.enable config.home-manager.users.teto.services.ollama.port
    ++ lib.optional config.home-manager.users.teto.services.llama-cpp.enable config.home-manager.users.teto.services.llama-cpp.port
    ++ lib.optionals config.services.harmonia-dev.cache.enable [
      443
      80
    ];

  firewall.allowedUDPPorts = [ ];

  # dedicated to printer
  # interfaces.enp11s0.ipv4 = {
  #   addresses = [
  #                {
  #                  # apipa system
  #                  address = "169.254.1.10";
  #                  prefixLength = 16;
  #                  # metric = "800";
  #                }

  # to allow wireshark to capture from netlink
  # networking.localCommands = ''
  #   ip link show nlmon0
  #   if [ $? -ne 0 ]; then
  #     ip link add nlmon0 type nlmon
  #     ip link set dev nlmon0 up
  #   fi
  # '';

  # 192.168.1.254
  # defaultGateway = {
  #   address = "131.211.84.1";
  #   interface = "enp3s0";
  #   source = "131.211.84.2";
  # };

  # mostly to add blocklsit
  # hostFiles
}
