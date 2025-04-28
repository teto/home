/*
  Most of it stolen from
  https://github.com/junegunn/fzf/wiki/Examples-(completion)#zsh-pass
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.fzf;

  # copied from hm/modules/programs/fzf.nix
  zshIntegration =
    # if hasShellIntegrationEmbedded then
      ''
        if [[ $options[zle] = on ]]; then
          eval "$(${lib.getExe cfg.package} --zsh | sed -e '/zmodload/s/perl/perl_off/' -e '/selected/s#fc -rl#fc -rlt "%d/%b %H:%M:%S"#')"
        fi
      '';
in
{
  options = {
    programs.fzf = {
      enableLiveRegex = lib.mkEnableOption "test";
      zshGitCheckoutAutocompletion = lib.mkEnableOption "zsh git checkout autocompletion";
      enableClipboardSelector = lib.mkEnableOption "clipboard";
      zshPassCompletion = lib.mkEnableOption "ZSH pass completion";
      manix = lib.mkEnableOption "manix";

      showLastUse = lib.mkEnableOption "Show last use";

      # useFdForCompgen = lib.mkEnableOption "compgenPath";
      # custom = lib.mkOption {
      #   default = false;
      #   type = lib.types.bool;
      #   description = ''
      #     Whether to enable Fish integration.
      #   '';
      # };
    };
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.enableLiveRegex (
      let
        fzfCompgen = ''
          # Use fd (https://github.com/sharkdp/fd) instead of the default find
          # command for listing path candidates.
          # - The first argument to the function ($1) is the base path to start traversal
          # - See the source code (completion.{bash,zsh}) for the details.
          _fzf_compgen_path() {
            fd --hidden --follow --exclude ".git" . "$1"
          }

          # Use fd to generate the list for directory completion
          _fzf_compgen_dir() {
            fd --type d --hidden --follow --exclude ".git" . "$1"
          }
        '';
      in
      {
        programs.bash.initExtra = fzfCompgen;
        programs.zsh.initContent = fzfCompgen;
      }
    ))

    (lib.mkIf cfg.enableLiveRegex {

      programs.bash.initExtra = ''
        fzf-manix() {
          manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | fzf --preview="manix '{}'" | xargs manix
        }
      '';
    })

    (lib.mkIf cfg.enableLiveRegex {

      programs.bash.initExtra = ''

        # alternative using ripgrep-all (rga) combined with fzf-tmux preview
        # This requires ripgrep-all (rga) installed: https://github.com/phiresky/ripgrep-all
        # This implementation below makes use of "open" on macOS, which can be replaced by other commands if needed.
        # allows to search in PDFs, E-Books, Office documents, zip, tar.gz, etc. (see https://github.com/phiresky/ripgrep-all)
        # find-in-file - usage: fif <searchTerm> or fif "string with spaces" or fif "regex"
        fif() {
            if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
            local file
            file="$(rga --max-count=1 --ignore-case --files-with-matches --no-messages "$*" | fzf-tmux +m --preview="rga --ignore-case --pretty --context 10 '"$*"' {}")" && echo "opening $file" && open "$file" || return 1;
        }
      '';

    })
    (lib.mkIf cfg.zshGitCheckoutAutocompletion {

      programs.zsh.initContent = ''
        _fzf_complete_git() {
            ARGS="$@"
            local branches
            branches=$(git branch -vv --all)
            if [[ $ARGS == 'git co'* ]]; then
                _fzf_complete --reverse --multi -- "$@" < <(
                    echo $branches
                )
            else
                eval "zle ''${fzf_default_completion:-expand-or-complete}"
            fi
        }

        _fzf_complete_git_post() {
            awk '{print $1}'
        }

      '';

    })

    
    # TODO do https://github.com/junegunn/fzf/issues/4346#issuecomment-2810047340
    (lib.mkIf cfg.showLastUse {

      # FZF_CTRL_R_OPTS
      programs.fzf.historyWidgetOptions = ["--with-nth 2"];

      programs.zsh.initContent = ''
        ${zshIntegration}
        '';
    })

    (lib.mkIf cfg.zshPassCompletion {

      programs.zsh.initContent = ''
        _fzf_complete_pass() {
          _fzf_complete +m -- "$@" < <(
            local prefix
            prefix="''${PASSWORD_STORE_DIR:-$HOME/.password-store}"
            command find -L "$prefix" \
              -name "*.gpg" -type f | \
              sed -e "s#''${prefix}/\{0,1\}##" -e 's#\.gpg##' -e 's#\\#\\\\#' | sort
          )
        }
      '';
    })

    # actually exists already "cliphist-fzf"
    # alias fzf-clip to it ?
    # (lib.mkIf cfg.enableClipboardSelector {
    #
    #   home.packages = let
    #     # writeShellApplication
    #     fzf-clip = pkgs.writeShellApplication {
    #       name = "fzf-clip";
    #       runtimeInputs = [
    #       ];
    #
    #       text = ''
    #         cliphist list | fzf --no-sort | cliphist decode | wl-copy
    #       '';
    #     };
    #   in [
    #     fzf-clip
    #   ];
    # })
  ];
}
