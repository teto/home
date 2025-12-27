{ config, ... }:
{
  group = "nginx";
  # cfg.group;
  isSystemUser = true;

  uid = config.ids.uids.nginx;
}
