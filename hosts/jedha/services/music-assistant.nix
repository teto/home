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
  # there is no declarative setting to tell it where to listen to, one has to click
  # an UI setting

  extraOptions = [
    "--log-level"
    "DEBUG"
  ];

  providers = [
    "mpd" # yet not available ?
    "jellyfin"
    "musiccast"
  ];

}
