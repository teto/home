{ config, pkgs, lib,  ... } @ args:
{

  programs.nushell = {
    enable = true;
		   configFile.text = ''
      let $config = {
        filesize_metric: false
        table_mode: rounded
        use_ls_colors: true
      }
    '';
    envFile.text = ''
      let-env FOO = 'BAR'
    '';


    # settings = {
    #       edit_mode = "vi";
    #       startup = [ "alias ll [] { ls -l }" "alias e [msg] { echo $msg }" ];
    #       key_timeout = 10;
    #       completion_mode = "circular";
    #       no_auto_pivot = true;
    # };
  };

}

