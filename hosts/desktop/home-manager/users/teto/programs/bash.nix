{ secretsFolder, ... }:
{

    # goes to .profile
    sessionVariables = {
      HISTTIMEFORMAT = "%d.%m.%y %T ";
      # CAREFUL
      # HISTFILE="$XDG_CACHE_HOME/bash_history";

    };

    shellAliases = {
      nix-stray-roots = ''nix-store --gc --print-roots | egrep -v "^(/nix/var|/run/\w+-system|\{memory)"'';
    };

    # source_if_exists
    initExtra = ''
      # enable vimode
      set -o vi

      source $XDG_CONFIG_HOME/bash/aliases.sh
      source $XDG_CONFIG_HOME/bash/lib.sh
      source $XDG_CONFIG_HOME/bash/bashrc.sh || true
    '';
  }

