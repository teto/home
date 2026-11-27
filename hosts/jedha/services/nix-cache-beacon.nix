{ config, ... }:
{
  # Announce cache to the local network
  advert = {
    enable = true;

    # Port number of the cache server to advertise, ie. harmonia port
    # harmonia port is at 5000
    port = 5000;
    # Harmonia port, doesn't exist, it is merged with "bind" option
    # port = config.services.harmonia.settings.port;
    # we should be able to do without
    # hostname = "${config.networking.fqdnOrHostName}";

    hostname = "${config.networking.hostName}";
  };

  # Enable local binary cache using discovered caches on the local network
  cache.enable = true;
}
