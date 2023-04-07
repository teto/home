{ config, pkgs, secrets, options, lib, ... }:
{
  users.users.root = {
    # isNormalUser = true; # creates home/ sets default shell
    # uid = 1000;
    # once can set initialHashedPassword too
    initialPassword = secrets.users.root.defaultPassword;
    # shell = pkgs.zsh;
    # openssh.authorizedKeys.keyFiles = [ ./keys/root_gitolite.pub ];
	programs.neovim = {
	  enable = true;
	  defaultEditor = true;
	};


  };
}

