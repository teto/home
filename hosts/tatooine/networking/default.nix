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

  useNetworkd = true;

  hosts = {

    # temporary hack
    "192.168.1.83" = [ "llamacpp.jedha.home" ];

    # a test, better would be to have nginx recognize another thing
    # todo use from lib
    # "10.100.0.1" = [ "neotokyo.local" ];
  };

}
