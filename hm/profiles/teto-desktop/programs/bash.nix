{
  pkgs,
  config,
  flakeSelf,
  lib,
  secretsFolder
  , ... 
}:
let 
  inherit (lib) mkRemoteBuilderDesc;
  builder_neotokyo = mkRemoteBuilderDesc "3.0" 
  (pkgs.tetosLib.nixosConfToBuilderAttr 
    {
      sshKey = "${secretsFolder}/ssh/id_rsa";
      # I might need to set it ?
      publicHostKey = null;
    }
    flakeSelf.nixosConfigurations.neotokyo)
  ;

  builder_jedha = mkRemoteBuilderDesc "3.0" 
  (pkgs.tetosLib.nixosConfToBuilderAttr 
    {
      sshKey = "${secretsFolder}/ssh/id_rsa";
      # I might need to set it ?
      publicHostKey = null;
    }
    flakeSelf.nixosConfigurations.jedha)
  ;

    # TODO add jedha
    # flakeSelf.deploy.nodes.jedha;
in
{

  # goes to .profile
  sessionVariables = {
      TETOS_0 = builder_neotokyo;
      TETOS_1 = builder_jedha;

    HISTTIMEFORMAT = "%d.%m.%y %T ";
    # CAREFUL
    # HISTFILE="$XDG_CACHE_HOME/bash_history";
    CDPATH = "$HOME/neovim:$HOME/nova";
  };
  historyFile = "${config.xdg.cacheHome}/bash_history";

  shellAliases = {
      lg = "lazygit";
      # trans aliases{{{
      fren = "trans -from fr -to en ";
      enfr = "trans -from en -to fr ";
      jpfr = "trans -from ja -to fr ";
      frjp = "trans -from fr -to ja ";
      jpen = "trans -from ja -to en ";
      enjp = "trans -from en -to ja ";
      # }}}

      nixpaste = "curl -F \"text=<-\" http://nixpaste.lbr.uno";


  };

  # source_if_exists
  initExtra = ''
    source $XDG_CONFIG_HOME/bash/aliases.sh
    source $XDG_CONFIG_HOME/bash/lib.sh
    source $XDG_CONFIG_HOME/bash/bashrc.sh || true
  '';

}
