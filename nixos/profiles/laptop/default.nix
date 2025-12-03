{
  config,
  lib,
  pkgs,
  ...
}:
{
  # package-sets.yubikey = true;

  # use tuned ?
  powerManagement = {
    powertop.enable = true;
    # cpuFreqGovernor = "powersave";
  };

  services.logind = {
    settings.Login = {
      # conflicted with another value
      #   RuntimeDirectorySize="6G";

      # see https://bbs.archlinux.org/viewtopic.php?id=225977 for problems with LID
      # lidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitch = "suspend";
    };
  };
}
