{
  config,
  flakeSelf,
  lib,
  secretsFolder,
  ...
}:
let

  # TODO add jedha
  # flakeSelf.deploy.nodes.jedha;
in
{

  # goes to .profile
  sessionVariables = {

    HISTTIMEFORMAT = "%d.%m.%y %T ";
    # CAREFUL
    # HISTFILE="$XDG_CACHE_HOME/bash_history";

  };

  # remove ?
  historyFile = "${config.xdg.cacheHome}/bash_history";

  shellAliases = {

    # nixpaste = "curl -F \"text=<-\" http://nixpaste.lbr.uno";
    m = "neomutt"; # or meli ?
    ns = "nix-shell";

    # ls aliases {{{
    ld = "eza -lD";
    lf = "eza -lF --color=always | grep -v /";
    lh = "eza -dl .* --group-directories-first";
    # }}}

    #mostly for testin
    # dfh="df --human-readable";
    # duh="du --human-readable";
    # --reverse|head";
    latest = "eza --sort newest -l | tail ";
    # kitty
    kcat = "kitty +kitten icat";

  }
  # or rather should depend on eza ?
  // lib.optionalAttrs (!config.programs.lsd.enable) {

    lt = "eza -al --sort=modified";
    # we have to add -g (--group) else it's hidden by default
    ll = lib.mkForce "eza -al -g --group-directories-first";

  };

  # source_if_exists
  #     source $XDG_CONFIG_HOME/bash/lib.sh
  initExtra = ''
    source $XDG_CONFIG_HOME/bash/aliases.sh
    source $XDG_CONFIG_HOME/bash/bashrc.sh || true
  '';

}
