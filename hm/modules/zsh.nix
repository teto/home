{
  config,
  lib,
  pkgs,
  flakeSelf,
  secrets,
  withSecrets,
  ...
}:

with lib;

let
  cfg = config.programs.zsh;

  # /tree/master/plugins/zbell
  termTitleSubmodule = types.submodule (import ./title-submodule.nix);

  zbellModule = types.submodule {
    options = {

      enable = mkEnableOption "Z-bell";

      ignore = mkOption {
        type = types.listOf types.str;
        # add $EDITOR
        default = [
          "man"
          "$EDITOR"
        ];
        description = "The list of programs to ignore.";
      };
    };
  };
in
{

  options = {
    programs.zsh = {

      enableTetoConfig = lib.mkEnableOption "Things I am used to";

      mcfly = mkOption {
        # type = termTitleSubmodule;
        default = {
          enable = false;
        };
        # export MCFLY_RESULTS_SORT=LAST_RUN
        # MCFLY_RESULTS=50
        # MCFLY_PROMPT="❯"
        # MCFLY_HISTORY_LIMIT
        # MCFLY_KEY_SCHEME=vim
        # MCFLY_DELETE_WITHOUT_CONFIRM=true
        # MCFLY_INTERFACE_VIEW=BOTTOM
        # MCFLY_DISABLE_MENU=TRUE
        # description = ''
        #   Update terminal title.
        # '';
      };

      # enable = mkEnableOption "Some custom zsh functions";
      enableProfiling = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to enable Fish integration.
        '';
      };

      enableFancyCursor = mkOption {
        default = true;
        type = types.bool;
        description = ''
          Enable fancy cursor.
        '';
      };

      # todo move to shell module ?
      enableFancyCtrlZ = mkOption {
        default = true;
        type = types.bool;
        description = ''
          Have Ctrl+z run 'fg'
        '';
      };

      zbell = mkOption {
        # default = true;
        # plugins/zbell/zbell.plugin.zsh
        type = zbellModule;
        default = {
          enable = false;
        };
        description = ''
          Whether to enable Fish integration.
        '';
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.enableProfiling {

      # programs.zsh.initContentFirst = lib.mkBefore "zmodload zsh/zprof";
      # programs.zsh.initContent = lib.mkAfter "zprof";

      home.file.".config/zsh/.zshrc".text = mkMerge [
        (lib.mkBefore "zmodload zsh/zprof")
        (lib.mkAfter "zprof")
      ];
    })

    (mkIf cfg.enableFancyCursor {
      programs.zsh.initContent = ''
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
        zle -N zle-keymap-select
      '';
    })

    (mkIf cfg.mcfly.enable {

      # ${}
      programs.zsh.initContent = ''
        export MCFLY_RESULTS_SORT=LAST_RUN
        export MCFLY_RESULTS=200
        export MCFLY_FZF_NO_STRICT_ORDERING=1
        # export MCFLY_PROMPT="❯"
        # export MCFLY_HISTORY_LIMIT

        eval "$(${pkgs.mcfly}/bin/mcfly init zsh)"
        eval "$(${pkgs.mcfly-fzf}/bin/mcfly-fzf init zsh)"
      '';
    })

    (mkIf cfg.zbell.enable {
      # TODO source zbell
      programs.zsh.initContent = "";
    })

    (mkIf cfg.enableTetoConfig {
      programs.zsh = {
        history = {
          path = "${config.xdg.cacheHome}/zsh_history";
        };

        sessionVariables =
          config.programs.bash.sessionVariables
          // (lib.optionalAttrs withSecrets {
            # HISTFILE="$XDG_CACHE_HOME/zsh_history";
            # TODO load this from sops instead
          });

        autosuggestion.enable = true;
        autosuggestion.highlight = "fg=#d787ff,bold";

        initContent = ''
          source $ZDOTDIR/zshrc
        '';

      };
    })
  ]);
}
