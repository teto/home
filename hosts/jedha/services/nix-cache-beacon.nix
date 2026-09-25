{ config, ... }:
{
  # Announce cache to the local network
  advert = {
    enable = true;
    port = 5028;
    # Harmonia port, doesn't exist, it is merged with "bind" option
    # port = config.services.harmonia.settings.port;
    # we should be able to do without
    hostname = "${config.networking.hostName}";
  };

  # Enable local binary cache using discovered caches on the local network
  cache.enable = true;
}
