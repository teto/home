{
  config,
  lib,
  pkgs,
  ...
}:
{
  enable = false;
  settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };
}
