{ config, pkgs, lib,  ... } @ args:
let 
    secrets = import ../../nixpkgs/secrets.nix;

  mkRemoteBuilderDesc = machine:
	with lib;
      concatStringsSep " " ([
        "${optionalString (machine.sshUser != null) "${machine.sshUser}@"}${machine.hostName}"
        (if machine.system != null then machine.system else if machine.systems != [ ] then concatStringsSep "," machine.systems else "-")
        (if machine.sshKey != null then machine.sshKey else "-")
        (toString machine.maxJobs)
        (toString machine.speedFactor)
        (concatStringsSep "," (machine.supportedFeatures ++ machine.mandatoryFeatures))
        (concatStringsSep "," machine.mandatoryFeatures)
      ]
	  # assume we r always > 2.4
      # ++ optional (isNixAtLeast "2.4pre") (if machine.publicHostKey != null then machine.publicHostKey else "-"));
	  # ++ (if machine.publicHostKey != null then machine.publicHostKey else "-")
	  );
in
{
  programs.zsh = {
      enable = true;

	  enableFzfGit = true;

	  # $HOME is prepend hence the issues
      dotDir = ".config/zsh";
      # autosuggestion.enable = true;
      sessionVariables = {
        # HISTFILE="$XDG_CACHE_HOME/zsh_history";
        # TODO load this from sops instead
        GITHUB_TOKEN = secrets.githubToken;
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
		path = "${config.xdg.cacheHome}/zsh_history";
		share = true;
		extended = true; # save timestamp
      };

      shellAliases = {
	   # trying to generate aliases replacing RUNNER2
	   #  l
		# BUILDER2 = 
      } // config.programs.bash.shellAliases;

      autocd = true;

      initExtraFirst = "
      ";

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
		export RUNNER1="${mkRemoteBuilderDesc secrets.nova-runner-1}"
		export RUNNER2="${mkRemoteBuilderDesc secrets.nova-runner-2}"
		export RUNNER3="${mkRemoteBuilderDesc secrets.nova-runner-3}"

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
      enableFancyCursor = true;
      enableSetTermTitle = true;
      enableProfiling = false;
  };
}
