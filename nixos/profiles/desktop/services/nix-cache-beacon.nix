{
  # Announce cache to the local network
  # advert = {
  #   enable = true;
  #   port = 5000;
  #   # port = config.services.harmonia-dev.settings.port; # Harmonia port
  # };

  # Enable local binary cache using discovered caches on the local network
  cache = {
    enable = true;
    addSubstituter = true;
    timeout = 3.0; # seconds

    # listenAddresses = lib.mkOption {
    #   type = lib.types.listOf lib.types.str;
    #   default = [ "[::]:5028" ];
    verbose = true;
  };
}
