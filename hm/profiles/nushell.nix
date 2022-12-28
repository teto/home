{ config, pkgs, lib, ... }:
{

  programs.nushell = {
    enable = true;

	shellAliases = config.programs.bash.shellAliases;
	# {

	#  ll = "ls -l";
	# };

    # configFile.text = ''
    # let $config = {
    # filesize_metric: false
    # table_mode: rounded
    # use_ls_colors: true
    # banner: true
    # }
    # '';
    # envFile.text = ''
    # let-env FOO = 'BAR'
    # '';


    # settings = {
    #       edit_mode = "vi";
    #       startup = [ "alias ll [] { ls -l }" "alias e [msg] { echo $msg }" ];
    #       key_timeout = 10;
    #       completion_mode = "circular";
    #       no_auto_pivot = true;
    # };
  };

}

