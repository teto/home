{ config, pkgs, lib,  ... } @ args:
{

  programs.nushell = {
    enable = true;
    settings = {
          edit_mode = "vi";
          startup = [ "alias ll [] { ls -l }" "alias e [msg] { echo $msg }" ];
          key_timeout = 10;
          completion_mode = "circular";
          no_auto_pivot = true;
    };
  };

}

