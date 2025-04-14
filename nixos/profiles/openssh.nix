{
  config,
  ...
}:
{

  services.openssh = {
    # kinda experimental
    # openssh.banner = "Hello world";

    # # for sshfs edit or scp
    allowSFTP = true;
    # needed since default is true !
    # listenAddresses = [
    #   { addr = "0.0.0.0"; port = 64022; }
    # ];

    startWhenNeeded = true;

    # authorizedKeysFiles = [
    #   "~/.ssh/id_rsa.pub"
    # ];
    # new format
    settings = {
      LogLevel = "VERBOSE";
      KbdInteractiveAuthentication = false;
      # PasswordAuthentication = false;
      # PermitRootLogin = "no";
      X11Forwarding = false;
    };
  };
}
