{
  config,
  secrets,
  dotfilesPath,
  pkgs,
  ...
}:
{
  home.sessionVariables = {
    ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
  };

  programs.zsh = {
    enable = true;

    # $HOME is prepend hence the issues
    dotDir = "${config.xdg.configHome}/zsh";

    sessionVariables = {

    };
    history = {
      # HISTSIZE
      # loaded in memory, careful since it slows down zsh
      size = 1000;
      save = 1000000;
      ignoreDups = true;
      # defined as HISTFILE="$HOME/${cfg.history.path}"
      # https://github.com/nsnam/bake-git
      # TODO fix
      share = true;
      extended = true; # save timestamp
    };

    shellAliases = {
      # trying to generate aliases replacing RUNNER2
      #  l
      # BUILDER2 =
      ".." = "cd ..";
      "..." = "cd ../..";

    }
    // config.programs.bash.shellAliases;

    autocd = true;

    # https://github.com/nix-community/home-manager/pull/4360
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "brackets"
        "pattern"
        "cursor"
      ];
      # highlighters = [ "brackets" ];
      styles = {
        comment = "fg=black,bold";
      };
    };

    enableCompletion = true;
    #   bindkey "^R" history-incremental-search-backward
    #   bindkey "^K"      kill-whole-line                      # ctrl-k
    #   bindkey "^A"      beginning-of-line                    # ctrl-a
    #   bindkey "^E"      end-of-line                          # ctrl-e
    #   bindkey "[B"      history-search-forward               # down arrow
    #   bindkey "[A"      history-search-backward              # up arrow
    #   bindkey "^D"      delete-char                          # ctrl-d
    #   bindkey "^F"      forward-char                         # ctrl-f
    #   bindkey "^B"      backward-char                        # ctrl-b
    # bindkey ‘^P’ up-line-or-beginning-search
    # bindkey ‘^N’ down-line-or-beginning-search

    # adds bash compatibility layer for autocompletion. Adds 'complete' for instance
    # used for jinko-seeder
    # is it going to be merged with compinit ?
    # completionInit = ''
    #   autoload -U compinit && compinit
    #   autoload -U bashcompinit; bashcompinit
    # '';

    # source ${pkgs.awscli2}/share/zsh/site-functions/_aws
    # initExtraFirst
    # auto
    initContent = ''

      # workaround aws drv bug see https://github.com/NixOS/nixpkgs/issues/275770#issuecomment-1977471765
      # Default to standard vi bindings, regardless of editor string
      bindkey -v
      # we can't bind emacs and vi at the same time so this adds emacs'
      bindkey "^A" beginning-of-line
      bindkey "^E" end-of-line
      bindkey "^K" kill-line
      bindkey "^L" clear-screen
      bindkey "^U" kill-whole-line
      bindkey "^W" backward-kill-word
      bindkey "^Y" yank
      autoload -U history-search-end
      zle -N history-beginning-search-backward-end history-search-end
      zle -N history-beginning-search-forward-end history-search-end
      bindkey '^P' history-beginning-search-backward-end
      bindkey '^N' history-beginning-search-forward-end

      # VERY IMPORTANT else zsh can eat last line
      setopt prompt_sp
      # very magic, if glob doesn't find anything then abort the glob
      setopt no_nomatch
    '';

    # https://github.com/atweiden/fzf-extras
    # the zsh script does nothing yet
    # Bug open fzf always
    # emulate sh -c 'source "${fzf-extras}/fzf-extras.sh";'
    # source "${fzf-extras}/fzf-extras.zsh";
    # loginExtra = ''

    # '';

    # custom module
    enableFancyCursor = true;
    # termTitle.enable = true;
    enableProfiling = false;

  };
}
