{
  config,
  lib,
  pkgs,
  ...
}:
{

  interfaces = {
    wg = {

      ips = [ "10.100.0.3/24" ];

    };
  };
}
