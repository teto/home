{
  lib,
  ...
}:
{
  enable = true;
  enableTetoConfig = true;

  sessionVariables = {
    # HISTTIMEFORMAT = "%d.%m.%y %T ";
    # CAREFUL
    CDPATH = "$CDPATH:$HOME/neovim";
  };

  completionInit = ''
    autoload -U compinit && compinit
    autoload -U bashcompinit; bashcompinit
  '';
  # initContent = lib.mkBefore ''
  #   autoload -U +X bashcompinit && bashcompinit
  #   '';
}
