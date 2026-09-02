{
  config,
  lib,
  ...
}:
{
  networkmanager = {
    enable = true;
  };

  useNetworkd = true;

  hosts = {
    # a test, better would be to have nginx recognize another thing
    # todo use from lib
    "10.100.0.1" = [ "neotokyo.local" ];
  };

}
