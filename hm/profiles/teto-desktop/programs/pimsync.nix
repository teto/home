{ config, ... }:
{
  enable = true;

  settings = [
    {

      name = "status_path";
      params = [ "${config.xdg.dataHome}/pimsync/status" ];
    }
  ];
}
