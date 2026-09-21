{
  config,
  lib,
  pkgs,
  ...
}:
{

  # TODO add to nginx
  # 8097
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

}
