{ config, lib, ... }:
{
  allowedTCPPorts = [
    5028 # pour nix-cache-beacon
  ]
  ++ lib.optional config.home-manager.users.teto.services.ollama.enable config.home-manager.users.teto.services.ollama.port
  ++ map (instance: instance.port) (
    lib.filter (instance: instance.enable) (
      lib.attrValues config.home-manager.users.teto.services.llama-cpp.instances
    )
  )
  ++ lib.optionals config.services.harmonia.cache.enable [
    443
    80
  ]

  ++ lib.optionals config.home-manager.users.teto.services.mpd.enable [
    config.home-manager.users.teto.services.mpd.network.port
    8000 # http stream
  ];

  allowedUDPPorts = [ ];

}
