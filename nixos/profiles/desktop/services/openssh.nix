{
  # systemd.services."<service-name>".wantedBy = lib.mkForce [ ];

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
