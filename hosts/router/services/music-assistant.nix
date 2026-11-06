{
  ...
}:
{

  # advertised on 8927 ?
  services.music-assistant = {
    # this is shit
    enable = false;

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
