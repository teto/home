{ config, lib, ... }:
{
  hostName = "jedha"; # Define your hostname.

  # creates problem with buffalo check if it blocks requests or what
  # it is necessary to use dnssec though :(
  resolvconf.dnsExtensionMechanism = false;
  resolvconf.dnsSingleRequest = false;

  firewall.allowedTCPPorts =
    lib.mkIf config.home-manager.users.teto.services.ollama.enable
      # config.home-manage
      [ config.home-manager.users.teto.services.ollama.port ];

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
