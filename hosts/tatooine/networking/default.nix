{
  config,
  lib,
  ...
}:
{
  # it is necessary to use dnssec though :(
  # hostId
  hostName = "tatooine"; # Define your hostname.

  networkmanager = {
    enable = true;
  };

  # use new framework
  nftables.enable = true;

  useNetworkd = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # useDHCP = lib.mkDefault true;


  hosts = {

    # temporary hack
    "192.168.1.83" = [ "llamacpp.jedha.home" ];

    # a test, better would be to have nginx recognize another thing
    # todo use from lib
    # "10.100.0.1" = [ "neotokyo.local" ];
  };

}
