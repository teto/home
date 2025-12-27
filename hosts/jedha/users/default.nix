{
  config,
  lib,
  pkgs,
  ...
}:
{

  groups.nginx.gid = config.ids.gids.nginx;
}
