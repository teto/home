{ config, ... }:
{
  # Announce cache to the local network
  advert = {
    enable = true;
    port = 5000;
    # Harmonia port, doesn't exist, it is merged with "bind" option
    # port = config.services.harmonia-dev.settings.port; 
  };

  # Enable local binary cache using discovered caches on the local network
  cache.enable = true;
}
