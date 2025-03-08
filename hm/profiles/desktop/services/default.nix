{ pkgs, ... }:
{
  mujmap = {
    enable = true;
    verbose = true;

    package = pkgs.mujmap-unstable;
  };
}
