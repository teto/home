{ config, pkgs, lib, secrets, 
flakeInputs,
... }:
{
  imports = [
   ../../../hm/profiles/bash.nix
   # ../../profiles/bash.nix
  ];

  programs.bash = {

    # goes to .profile
    sessionVariables = 
     {
      HISTTIMEFORMAT = "%d.%m.%y %T ";
      # CAREFUL 
      # HISTFILE="$XDG_CACHE_HOME/bash_history";

    };

    # 
    initExtra = ''
     source  $XDG_CONFIG_HOME/zsh/aliases.sh
     '';
   };
 }
