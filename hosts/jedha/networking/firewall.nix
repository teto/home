{ config, lib, ... }:
{
  allowedTCPPorts =
    lib.optional config.home-manager.users.teto.services.ollama.enable config.home-manager.users.teto.services.ollama.port
    ++ lib.optional config.home-manager.users.teto.services.llama-cpp.enable config.home-manager.users.teto.services.llama-cpp.port
    ++ lib.optionals config.services.harmonia-dev.cache.enable [
      443
      80
    ]

    ++ lib.optionals config.home-manager.users.teto.services.mpd.enable [
      config.home-manager.users.teto.services.mpd.network.port
      8000 # http stream
    ];

  allowedUDPPorts = [ ];

}
