{
  lib,
  ...
}:
{
  enable = false; # I like fish now
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
  };

  completionInit = ''
    autoload -U compinit && compinit
    autoload -U bashcompinit; bashcompinit
  '';
  # initContent = lib.mkBefore ''
  #   autoload -U +X bashcompinit && bashcompinit
  #   '';
}
