{ config, pkgs, ... }:
{
  enable = true;

  # package = pkgs.pimsync-dev;

  settings = [
    {

      name = "status_path";
      params = [ "${config.xdg.dataHome}/pimsync/status" ];
    }
  ];
}
