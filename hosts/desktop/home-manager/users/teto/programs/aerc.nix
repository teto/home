{
  config,
  lib,
  pkgs,
  ...
}:
{

  programs.aerc = {
    enable = true;
    extraConfig.general.unsafe-accounts-conf = true;
  };
}
