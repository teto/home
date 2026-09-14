{ config, lib, pkgs, ... }:
{

  # advertised on 8927 ?
  services.music-assistant = {
  enable = true;

  extraOptions = [
        "--log-level"
        "DEBUG"
      ];

    providers = [
      "mpd"
      "jellyfin"
      "musiccast"
    ];

  };
}
