{
  config,
  lib,
  ...
}:
let

  # TODO add jedha
  # flakeSelf.deploy.nodes.jedha;
in
{
  termTitle.enable = true;

  # goes to .profile
  sessionVariables = {

    # used when calling "history"
    HISTTIMEFORMAT = "%d.%m.%y %T ";
    # CAREFUL
    # HISTFILE="$XDG_CACHE_HOME/bash_history";

  };

  # remove ?
  historyFile = "${config.xdg.cacheHome}/bash_history";

  shellAliases = {
    # provided as bin
    # nix-stray-roots = ''nix-store --gc --print-roots | egrep -v "^(/nix/var|/proc|/run/\w+-system|\{memory)" | less'';
    netstat_tcp = "netstat -ltnp";

    # m = "meli";
    # ns = "nix-shell";

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
    # ls aliases {{{
    # ld = "eza -lD";
    # lf = "eza -lF --color=always | grep -v /";
    # lh = "eza -dl .* --group-directories-first";
    # }}}

  };

  # source_if_exists
  #     source $XDG_CONFIG_HOME/bash/lib.sh
  initExtra = ''
    source $XDG_CONFIG_HOME/bash/manual.sh || echo "Fix or create a ~/.config/bash/manual.sh to silence this warning"
  '';

}
