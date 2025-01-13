{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.vdirsyncer = {
    enable = true;
    # Provide package from stable channel ?
    # package = pkgs.vdirsyncerStable;

  };

}
