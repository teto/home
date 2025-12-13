{ config, lib, ... }:
{
  hostName = "jedha";
  domain = "jedha.local"; # Define your hostname.

  # hosts = [];

  # creates problem with buffalo check if it blocks requests or what
  # it is necessary to use dnssec though :(
  resolvconf.dnsExtensionMechanism = false;
  resolvconf.dnsSingleRequest = false;

    # osConfig.config.networking.firewall = lib.mkIf cfg.openFirewall {
    #   allowedTCPPorts = [ cfg.port ];
    # };

  firewall.allowedTCPPorts =
    lib.optional config.home-manager.users.teto.services.ollama.enable
      config.home-manager.users.teto.services.ollama.port 
    ++ lib.optional config.home-manager.users.teto.services.llama-cpp.enable 
      config.home-manager.users.teto.services.llama-cpp.port 
    ++ lib.optionals config.services.harmonia.cache.enable [
      443
      80
    ];

  firewall.allowedUDPPorts = [ ];

  # to allow wireshark to capture from netlink
  # networking.localCommands = ''
  #   ip link show nlmon0
  #   if [ $? -ne 0 ]; then
  #     ip link add nlmon0 type nlmon
  #     ip link set dev nlmon0 up
  #   fi
  # '';

}
