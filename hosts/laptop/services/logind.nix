{

  # see https://nixos.org/nix-dev/2015-July/017657.html for problems
  # with /run/user/1000 size
  # size of tmpfs used by nix builds
  # usually
  # see cat /etc/systemd/logind.conf
  settings.Login = {
    # conflicted with another value
    #   RuntimeDirectorySize="6G";

    # see https://bbs.archlinux.org/viewtopic.php?id=225977 for problems with LID
    # lidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitch = "suspend";
  };
}
