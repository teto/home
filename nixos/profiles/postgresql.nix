{ config, pkgs, lib, ... }:
{
  services.postgresql = {
    enable = true;
	# /var/lib/postgresql/13/
	# do I really need it to work locally ?
	# port par defaut est 5050

	# should be a string
	# initialPasswordFile

	  # enableTCPIP = true; # if false, use TCP via localhost only or via socket

  };

  # see https://www.pgadmin.org/docs/pgadmin4/6.8/config_py.html

  environment.systemPackages = [

	  pkgs.pgadmin # freaking hell to install
	  pkgs.dbeaver # java, crashes often
  ];

  services.pgadmin = {
	# this one is painful
	# you have to create /var/lib/pgadmin and /var/log/pgadmin
	# and give pgadmin:users ownership of both folders
	# run the pgadmin pre-start systemd script is easier

	enable = false;
	initialEmail = "toto@doesnotexist.com";
	# "/home/teto/pgadmin.password";
	initialPasswordFile = pkgs.writeText "test" "toto";
  };

  # https://www.pgadmin.org/docs/pgadmin4/6.8/config_py.html
  # DATA_DIR="/var/lib/pgadmin"
  # environment.etc."pgadmin/config_system.py".text = ''
  # SERVER_MODE=None
  # '';


  # 
}

