{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.zsh;

in {

  options = {
    programs.zsh = {
      # enable = mkEnableOption "Some custom zsh functions";
      enableProfiling = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to enable Fish integration.
        '';
      };
      enableSetTermTitle = mkOption {
        default = true;
        type = types.bool;
        description = ''
          Whether to enable Fish integration.
        '';
      };

      enableFancyCtrlZ = mkOption {
        default = true;
        type = types.bool;
        description = ''
          Whether to enable Fish integration.
        '';
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.enableProfiling {

      programs.zsh.initExtraFirst = lib.mkBefore "zmodload zsh/zprof";
      programs.zsh.initExtra = lib.mkAfter "zprof";
    })

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

    (mkIf cfg.enableSetTermTitle {
    programs.zsh.initExtra = ''
      # works in termite
      function set_term_title (){
      # -n Do not add a newline to the output.

          # print -Pn "\e]0;$(echo "$1")\a"
          print -n '\e]0;'
          print -n "$1"
          print -nrD "@$PWD"
          print -n '\a'
      }

      update_term_title () {
          set_term_title $(pwd)
      }
      # set cursor depending in vi mode
      # inspired by http://lynnard.me/blog/2014/01/05/change-cursor-shape-for-zsh-vi-mode/
      # zle-line-init 
      # zle-line-finish
      # starship overrides it
      # https://unix.stackexchange.com/questions/547/make-my-zsh-prompt-show-mode-in-vi-mode?noredirect=1&lq=1
      zle-keymap-select () {
          if [ $KEYMAP = vicmd ]; then
          # the command mode for vi
          echo -ne "\e[2 q"
          else
          # the insert mode for vi
          # echo -ne "\e[4 q"
          echo -ne '\e[5 q'
          fi
      }
      # http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#ZLE-Functions
      # autoload zsh-mime-setup
      zle -N zle-keymap-select
      add-zsh-hook preexec set_term_title
      #add-zsh-hook zsh_directory_name
      add-zsh-hook precmd update_term_title
    '';
  })


    # home.packages = [ pkgs.pywal ];
    # home.sessionVariables = {
    #   CABAL_CONFIG="$XDG_CONFIG_HOME/cabal/config";
    #   # TODO move to data instead ?
    #   CABAL_DIR="$XDG_CACHE_HOME/cabal";
    # };
  ]);
}

