{
  # mirrors tatooine (desktop profile + host overrides)
  # keys come from nixos/users/teto/teto.nix
  services.openssh = {
    enable = true;
    ports = [ 12666 ];
    # for sshfs edit or scp
    allowSFTP = true;
    startWhenNeeded = false;
    settings = {
      LogLevel = "VERBOSE";
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      X11Forwarding = false;
    };
  };

}
