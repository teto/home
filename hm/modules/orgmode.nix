{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.orgmode;

in
{

  options = {
    programs.zsh = {
      enableFzfGit = mkEnableOption "Fzf-git";

      # # enable = mkEnableOption "Some custom zsh functions";
      # enableProfiling = mkOption {
      #   default = false;
      #   type = types.bool;
      #   description = ''
      #     Whether to enable Fish integration.
      #   '';
      # };

    };
  };

  config = mkIf cfg.enable (mkMerge [
    # (mkIf cfg.enableFzfGit {
    #   programs.zsh.initExtra = ''
    # source ${fzf-git-sh}/fzf-git.sh
    # '';
    # })

    (mkIf cfg.enableFancyCtrlZ {
      programs.zsh.initExtra = ''
        fancy-ctrl-z () {
          if [[ $#BUFFER -eq 0 ]]; then
            BUFFER="fg"
            zle accept-line
          else
            zle push-input
            zle clear-screen
          fi
        }
        zle -N fancy-ctrl-z
        bindkey '^Z' fancy-ctrl-z
      '';
    })

    # home.sessionVariables = {
    #   CABAL_CONFIG="$XDG_CONFIG_HOME/cabal/config";
    #   # TODO move to data instead ?
    #   CABAL_DIR="$XDG_CACHE_HOME/cabal";
    # };
  ]);
}


