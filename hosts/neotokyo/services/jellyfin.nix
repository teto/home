{
  # test with streamlink to mpv ?
  enable = true;
  # dataDir ?
  # group ?
  openFirewall = true;

  #
  user = "jellyfin";
  group = "media";

  # TODO use "media" as group, same for transmission
  # group =

  # services.jellyseerr.enable is a request manager for jellyfin
}
