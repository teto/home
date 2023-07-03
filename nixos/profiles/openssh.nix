{ config, pkgs, lib, ... }:
{

  services.openssh = {
    enable = true;
    # kinda experimental
    # services.openssh.banner = "Hello world";
    ports = [ 12666 ];

    # # for sshfs edit or scp
    allowSFTP = true;
    # needed since default is true !
    # listenAddresses = [
    #   { addr = "0.0.0.0"; port = 64022; }
    # ];

    startWhenNeeded = true;

    # extraConfig = ''
    # HostKey /home/teto/.ssh/server_id_rsa
    # '';

    # authorizedKeysFiles = [
    #   "~/.ssh/id_rsa.pub"
    # ];
    # authorizedKeys = { }

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
