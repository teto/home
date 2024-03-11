{ config
, secrets
, lib
, withSecrets
, ...
}:
{

  programs.zsh = {


    history = {
     path = "${config.xdg.cacheHome}/zsh_history";
    };

    sessionVariables = config.programs.bash.sessionVariables // 
     lib.optionalAttrs withSecrets {
     # HISTFILE="$XDG_CACHE_HOME/zsh_history";
     # TODO load this from sops instead
     GITHUB_TOKEN = secrets.githubToken;
     # TODO add it to sops
     OPENAI_API_KEY = secrets.OPENAI_API_KEY;
     CDPATH = "~/nova";
     # OPENAI_API_HOST = secrets.OPENAI_API_HOST;
    }
    
    // {
     # fre experiment

     FZF_CTRL_T_COMMAND="command fre --sorted";
     FZF_CTRL_T_OPTS="--tiebreak=index";
   };

  # test for 
  # - https://www.reddit.com/r/neovim/comments/17dn1be/implementing_mru_sorting_with_minipick_and_fzflua/
  # - https://lib.rs/crates/fre
   initExtra = ''
     fre_chpwd() {
       fre --add "$(pwd)"
     }
     typeset -gaU chpwd_functions
     chpwd_functions+=fre_chpwd


      # source $ZDOTDIR/zshrc.generated
      # if [ -f "$ZDOTDIR/zshrc" ]; then
      source $ZDOTDIR/zshrc
      # fi

      # used in some git aliases
      export REVIEW_BASE=master

     '';

    initExtraBeforeCompInit = /* zsh */ ''
      # zsh searches $fpath for completion files
      fpath+=( $ZDOTDIR/completions )
     '';

    # to disable loading of /etc/z* files
    # envExtra = '' 
    # setopt no_global_rcs
    # '';
    # kernel aliases {{{
    # nix messes up the escaping I think
    # kernel_makeconfig=''
    #   nix-shell -E 'with import <nixpkgs> {}; mptcp-manual.overrideAttrs (o: {nativeBuildInputs=o.nativeBuildInputs ++ [ pkgconfig ncurses ];})' --command "make menuconfig KCONFIG_CONFIG=$PWD/build/.config"
    #   '';
    # kernel_xconfig=''
    # nix-shell -E 'with import <nixpkgs> {}; linux.overrideAttrs (o: {nativeBuildInputs=o.nativeBuildInputs ++ [ pkgconfig qt5.qtbase ];})' --command 'make menuconfig KCONFIG_CONFIG=$PWD/build/.config'
    # '';
    # kernel_xconfig="make xconfig KCONFIG_CONFIG=build/.config"
    # }}}

    # custom module
    autosuggestion.enable = true;
    autosuggestion.highlight = "fg=#d787ff,bold";

   };
  }
