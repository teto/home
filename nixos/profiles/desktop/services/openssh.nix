{
  # systemd.services."<service-name>".wantedBy = lib.mkForce [ ];

  ports = [ 12666 ];

  # tu peux en avoir plusieurs sur ce mode
  # alors que on a
  # AuthorizedKeysFile %h/.ssh/authorized_keys %h/.ssh/authorized_keys2 /etc/ssh/authorized_keys.d/%u

  # # for sshfs edit or scp
  allowSFTP = true;

  startWhenNeeded = true;

  settings = {
    LogLevel = "VERBOSE";
    # kbdInteractiveAuthentication = false;
    KbdInteractiveAuthentication = false;
    PasswordAuthentication = false;
    PermitRootLogin = "no";
    X11Forwarding = false;
    # AuthorizedKeysCommandUser = "toto";
    # AuthorizedKeysFiles = ["tata" "toto"];
    # AuthorizedKeysCommandUser = "toto";
  };
}
