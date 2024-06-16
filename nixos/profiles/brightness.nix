{
  config,
  lib,
  pkgs,
  ...
}:
{

  # for android development
  programs.light = {
    enable = true;
    # make it work even in ttys !
    brightnessKeys = true;
  };
}
