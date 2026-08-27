{ config, lib, ... }:
{
  allowedTCPPorts =
    lib.optional config.services.rmfakecloud.enable config.services.rmfakecloud.port
    ++ lib.optional config.services.wyoming.satellite.enable 10700
    # services.wyoming.piper.servers
    ++ lib.optional config.services.wyoming.openwakeword.enable 10400
    # medium-en / uri
    ++ lib.optional config.services.wyoming.faster-whisper.servers.medium-fr.enable 10301
    ++ lib.optional config.services.wyoming.piper.servers.fr.enable 10200
    ++ [
      10301 # whisper service
      # 10400 # openwakeword
    ];

  allowedUDPPorts = [
    51820 # wireguard
  ];
}
