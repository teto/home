{ secretsFolder, ... }:
{
  programs.bash = {

    # goes to .profile
    sessionVariables = {
      HISTTIMEFORMAT = "%d.%m.%y %T ";
      # CAREFUL
      # HISTFILE="$XDG_CACHE_HOME/bash_history";

    };

    shellAliases = {
    };

    # source_if_exists
    initExtra = ''
      source $XDG_CONFIG_HOME/bash/aliases.sh
      source $XDG_CONFIG_HOME/bash/lib.sh
      source $XDG_CONFIG_HOME/bash/bashrc.sh || true
    '';
  };

  # xdg.configFile."teto-utils/lib.sh".text = ''
  xdg.configFile."bash/lib.sh".text = ''
    TETO_SECRETS_FOLDER=${secretsFolder}
  '';
}
