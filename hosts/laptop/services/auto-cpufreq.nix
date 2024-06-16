{
  config,
  lib,
  pkgs,
  ...
}:
{
  # services.auto-cpufreq.
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
