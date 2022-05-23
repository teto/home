{ config, pkgs, lib, ... }:
{
  services.postgresql = {
    enable = true;
	# do I really need it to work locally ?
	# port par defaut est 5050

	# should be a string
	# initialPasswordFile

	  # enableTCPIP = true; # if false, use TCP via localhost only or via socket

  };

  # 
}

