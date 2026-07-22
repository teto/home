{
  # test with streamlink to mpv ?
  enable = true;
  # dataDir ?
  # group ?
  # todo remove once we checked it worked against VPN
  openFirewall = true;

  #
  user = "jellyfin";
  group = "media";

  transcoding.enableSubtitleExtraction = true;
  # TODO use "media" as group, same for transmission
  # group =

  # services.jellyseerr.enable is a request manager for jellyfin
}
