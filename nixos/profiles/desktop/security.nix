{
  # don't forget to run ulimit -c unlimited to get the actual coredump
  # check thos comment to setup user ulimits https://github.com/NixOS/nixpkgs/issues/159964#issuecomment-1252682060
  # systemd.services."user@1000".serviceConfig.LimitNOFILE = "32768";
  # look at man limits.conf
  # cat /proc/sys/fs/file-max /proc/sys/fs/file-nr
  # fs.inotify.max_user_instances = 128
  # fs.inotify.max_user_watches = 8192
  # fs.inotify.max_queued_events = 16384
  # type: soft/hard/- (-=both soft and hard
  pam.services.swaylock = { };

  pam.loginLimits = [
    #
    # to avoid "Bad file descriptor" and "Too many open files" situations
    # ulimit -u

    # maximum number of open file descriptors
    {
      domain = "*";
      item = "nofile";
      type = "-";
      value = "70000";
    }
    # maximum locked-in-memory address space
    {
      domain = "*";
      item = "memlock";
      type = "-";
      value = "70000";
    }
  ];

  # dictated by https://nixos.wiki/wiki/Yubikey
  pam = {
    u2f = {
      enable = true;
      settings = {
        interactive = true; # Insert your U2F device, then press ENTER.
        cue = true; # will print Please touch the device.
      };
    };

    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
  };

  # users.motd =
  # security.pam.loginLimits = [
  #   {
  #     domain = "teto";
  #     type = "soft";
  #     item = "core";
  #     value = "unlimited";
  #   }
  #   {
  #     domain = "*";
  #     type = "hard";
  #     item = "memlock";
  #     value = "256";
  #   }
  # ];

}
