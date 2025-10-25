{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.vdirsyncer = {
    enable = false; # broken and replaced with pimsync
    # Provide package from stable channel ?
    # package = pkgs.vdirsyncerStable;

  };

}
