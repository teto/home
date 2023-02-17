{ config, pkgs, lib, ... }:
{

  services.openssh = {
    enable = false;
    # kinda experimental
    # services.openssh.banner = "Hello world";
    ports = [ 12666 ];

    # # for sshfs edit or scp
    allowSFTP = true;
    # type = types.enum ["yes" "without-password" "prohibit-password" "forced-commands-only" "no"];
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
      PasswordAuthentication = false;
      # PermitRootLogin = "no";
	  X11Forwarding = true;
    };

    # kbdInteractiveAuthentication = false;
    # logLevel = "VERBOSE";
    # permitRootLogin = "prohibit-password";
    # passwordAuthentication = false;

  };
}

