{ config, pkgs, lib,  ... } @ args:
{
  programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      # autosuggestion.enable = true;
      sessionVariables = {
        # HISTFILE="$XDG_CACHE_HOME/zsh_history";
        # TODO load this from sops instead
        # GITHUB_TOKEN = secrets.githubToken;
      };
      history = {
          save = 1000000;
          ignoreDups = true;
          # defined as HISTFILE="$HOME/${cfg.history.path}"
          # https://github.com/nsnam/bake-git
          # TODO fix
          path = "${config.xdg.cacheHome}/zsh_history";
          share = true;
          extended = true; # save timestamp
      };
      shellAliases = {
      } // config.programs.bash.shellAliases;

      autocd = true;

      initExtraFirst = "
      ";

      enableCompletion = false;
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

      initExtra = ''
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

        # source $ZDOTDIR/zshrc.generated
        # if [ -f "$ZDOTDIR/zshrc" ]; then
        source $ZDOTDIR/zshrc
        # fi

        # used in some git aliases
        export REVIEW_BASE=master
      ''
      ;

        # https://github.com/atweiden/fzf-extras
        # the zsh script does nothing yet
        # Bug open fzf always
        # emulate sh -c 'source "${fzf-extras}/fzf-extras.sh";'
        # source "${fzf-extras}/fzf-extras.zsh";
      # loginExtra = ''

      # '';

      initExtraBeforeCompInit = ''
        # zsh searches $fpath for completion files
        fpath+=( $ZDOTDIR/completions )
      '';

      # custom module
      enableFancyCursor = true;
      enableSetTermTitle = true;
      enableProfiling = false;
    };

  programs.bash = {
    enable = true;

    # goes to .profile
    sessionVariables = {
      HISTTIMEFORMAT="%d.%m.%y %T ";
      # HISTFILE="$XDG_CACHE_HOME/bash_history";
    };
    # "ignorespace"
    historyControl = [];
    historyIgnore = ["ls" "pwd"];
    # shellOptions = [ "histappend" "checkwinsize" "extglob" "globstar" "checkjobs" ];
    historyFile = "${config.xdg.cacheHome}/bash_history";
    # historyFile = "$XDG_CACHE_HOME/bash_history";
    shellAliases = {
      n="nix develop";
      nhs="nix shell ${toString ../../..}#nhs";
      ns="nix-shell";
      lg="lazygit";
      #mostly for testin
      # dfh="df --human-readable";
      # duh="du --human-readable";
      latest="ls -lt |head";
      fren="trans -from fr -to en ";
      enfr="trans -from en -to fr ";
      jpfr="trans -from ja -to fr ";
      frjp="trans -from fr -to ja ";
      jpen="trans -from ja -to en ";
      enjp="trans -from en -to ja ";
      dmesg="dmesg --color=always|less";

      netstat_tcp="netstat -ltnp";
      nixpaste="curl -F \"text=<-\" http://nixpaste.lbr.uno";

      # git variables {{{
      gl="git log";
      gs="git status";
      gd="git diff";
      ga="git add";
      gc="git commit";
      gcm="git commit -m";
      gca="git commit -a";
      gb="git branch";
      gch="git checkout";
      grv="git remote -v";
      gpu="git pull";
      gcl="git clone";
      # gta="git tag -a -m";
      gbr="git branch";
      # }}}

      # kitty
      kcat="kitty +kitten icat";

      # modprobe to use
      # might need to use -S as well
      # modprobe_exp="modprobe -d /home/teto/mptcp/build";
    };
  };

}
