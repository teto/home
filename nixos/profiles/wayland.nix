{ config, lib, pkgs, ... }:
{
  # necessary to be able to share screens (not sure why ...)
  xdg.portal = {
    wlr.enable = true;
    lxqt.enable = true;
  };
}
