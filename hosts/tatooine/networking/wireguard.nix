{
  config,
  lib,
  pkgs,
  ...
}:
{
  enable = false;

  interfaces = {
    wg = {

      ips = [ "10.100.0.3/24" ];

    };
  };
}
