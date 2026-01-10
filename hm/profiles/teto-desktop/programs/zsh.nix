{
  lib,
  ...
}:
{
  enable = true;
  enableTetoConfig = true;

  defaultKeymap = "viins";

  # kesak ?
  dirHashes = {
    docs = "$HOME/Documents";
    vids = "$HOME/Videos";
    dl = "$HOME/Downloads";
  };

  sessionVariables = {
    # CAREFUL
    CDPATH = "$HOME/neovim";
  };

  completionInit = ''
    autoload -U compinit && compinit
    autoload -U bashcompinit; bashcompinit
  '';
  # initContent = lib.mkBefore ''
  #   autoload -U +X bashcompinit && bashcompinit
  #   '';
}
