{
  config,
  lib,
  pkgs,
  ...
}:
{
  enable = true;
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
