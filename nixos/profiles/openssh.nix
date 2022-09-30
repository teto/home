{ config, pkgs, lib, ... }:
{

  services.openssh = {
    enable = true;
    # kinda experimental
    # services.openssh.banner = "Hello world";

    allowSFTP = true; # for sshfs edit
    # type = types.enum ["yes" "without-password" "prohibit-password" "forced-commands-only" "no"];
    # needed since default is true !
    # listenAddresses = [
    #   { addr = "0.0.0.0"; port = 64022; }
    # ];
    ports = [ 12666 ];
    startWhenNeeded = true;

	extraConfig = ''
	 HostKey /home/teto/.ssh/server_id_rsa
	'';

    # authorizedKeysFiles = [
    #   "~/.ssh/id_rsa.pub"
    # ];
    # authorizedKeys = { }

    # hostKeys to generate keys
    # hostKeys


	# new format
	settings = {
	 LogLevel = "VERBOSE";
	 KbdInteractiveAuthentication = false;
	 PasswordAuthentication = false;
	 PermitRootLogin = "prohibit-password";
	};

    # forwardX11 = true;
	 # kbdInteractiveAuthentication = false;
    # logLevel = "VERBOSE";
    # permitRootLogin = "prohibit-password";
    # passwordAuthentication = false;

  };
}
