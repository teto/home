{
  #   # see https://bbs.archlinux.org/viewtopic.php?id=225977 for problems with LID
  #   # lidSwitch = "ignore";
  lidSwitch = "suspend";
  #   lidSwitchDocked = "suspend";
  lidSwitchExternalPower = "ignore";

  # see https://nixos.org/nix-dev/2015-July/017657.html for problems
  # with /run/user/1000 size
  # size of tmpfs used by nix builds
  # usually
  # see cat /etc/systemd/logind.conf
  extraConfig = ''
    RuntimeDirectorySize=6G
  '';
}
