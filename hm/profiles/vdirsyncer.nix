{
  config,
  pkgs,
  lib,
  secrets,
  ...
}:
{

  services.vdirsyncer = {
    enable = true;
    # package = pkgs.pimsync;
  };
}
