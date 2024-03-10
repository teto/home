{ config, pkgs, lib, ... }:
{

    enable = true;
    # kinda experimental
    banner = "If you are not me, log off please";
    ports = [ 12666 ];

   # tu peux en avoir plusieurs sur ce mode
   # HostKey /etc/ssh/ssh_host_rsa_key
   # HostKey /etc/ssh/ssh_host_ed25519_key
   # alors que on a 
   # AuthorizedKeysFile %h/.ssh/authorized_keys %h/.ssh/authorized_keys2 /etc/ssh/authorized_keys.d/%u
	# hostKeys = [
	  # {
		# bits = 4096;
		# path = "/etc/ssh/ssh_host_rsa_key";
		# type = "rsa";
	  # }
	  # {
		# path = "/etc/ssh/ssh_host_ed25519_key";
		# type = "ed25519";
	  # }
   # ];


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

	# testing https://github.com/NixOS/nixpkgs/pull/215397
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
	  # Port = 42;
    };

    # kbdInteractiveAuthentication = false;
    # logLevel = "VERBOSE";
    # permitRootLogin = "prohibit-password";
    # passwordAuthentication = false;
   # settings = {
	 # AuthorizedKeysCommand = "true";
	 # AuthorizedKeysCommandUser = "nobody";
   # };

   # > /nix/store/94paffh2ns62jjwfhf419hrcs2lalw8d-sshd.conf-validated line 5: no argument after keyword "ListenAddresses"
   # > /nix/store/94paffh2ns62jjwfhf419hrcs2lalw8d-sshd.conf-validated line 33: keyword Port extra arguments at end of line
   # settings.Port = [ 42 ];
   # 
   # AuthorizedKeysCommandUser
   #     Specifies the user under whose account the AuthorizedKeysCommand is run.  It is recommended to  use  a  dedi‐
   #     cated  user  that has no other role on the host than running authorized keys commands.  If AuthorizedKeysCom‐
   #     mand is specified but AuthorizedKeysCommandUser is not, then sshd(8) will refuse to start.
   # 	 Port 320
	 # Port 42
   # extraConfig = ''
	# AuthorizedKeysFile %h/.ssh/authorized_keys %h/.ssh/authorized_keys2 /etc/ssh/authorized_keys.d/%ujjk
	 # AuthorizedKeysCommand none
	 # # La question est: est-ce que AuthorizedKeysCommandUser est utilise si 
	 # AuthorizedKeysCommandUser toto
	# '';

}

