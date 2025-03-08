{ secretsFolder, ... }:
{

  # goes to .profile
  sessionVariables = {
    HISTTIMEFORMAT = "%d.%m.%y %T ";
    # CAREFUL
    # HISTFILE="$XDG_CACHE_HOME/bash_history";
    CDPATH = "$CDPATH:$HOME/neovim";
  };

  shellAliases = {
  };

  # source_if_exists
  initExtra = ''
    source $XDG_CONFIG_HOME/bash/aliases.sh
    source $XDG_CONFIG_HOME/bash/lib.sh
    source $XDG_CONFIG_HOME/bash/bashrc.sh || true
  '';

}
