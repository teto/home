{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.shell;

  termTitleSubmodule = lib.types.submodule (import ./title-submodule.nix);
in
{
  options = {
    programs.shell = {
      enable = lib.mkEnableOption "shell";

      # todo move to shell module ?
      enableFancyCtrlZ = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = ''
          Have Ctrl+z run 'fg'
        '';
      };

      termTitle = lib.mkOption {
        type = termTitleSubmodule;
        default = {
          enable = false;
        };
        description = ''
          Update terminal title.
        '';
      };

    };
  };
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (
        let
          shellSetTitleFunctions = ''
            function set_term_title (){
              print -n "\e]0;$1\a"
            }

            set_term_title_for_new_prompt () {
                echo "set_term_title_for_new_prompt"
                set_term_title "$(pwd):'$3'"
            }
            # zsh passes
            set_term_title_for_program () {
                echo "set_term_title_for_program \$1: '$1' \$2: '$2' \$3: '$3'"
                set_term_title "program: $(pwd):'$3'"
            }
          '';

        in
        lib.mkIf cfg.termTitle.enable {

          # https://zsh.sourceforge.io/Doc/Release/Functions.html
          # preexec: Executed just after a command has been read and is about to be executed.
          # add-zsh-hook zsh_directory_name
          # autoload zsh-mime-setup
          # -n Do not add a newline to the output.
          # print -Pn "\e]0;$(echo "$1")\a"
          programs.zsh.initContent = ''
            ${shellSetTitleFunctions}


            # https://zsh.sourceforge.io/Doc/Release/Functions.html#index-preexec_005ffunctions
            # pass 3 arguments: non-expanded, expanded, fully-expanded
            add-zsh-hook preexec set_term_title_for_program
            # precmd: Executed before each prompt.
            add-zsh-hook precmd set_term_title_for_new_prompt
          '';

          # depending
          # in my case since I am using starship
          # https://starship.rs/advanced-config/#custom-pre-prompt-and-pre-execution-commands-in-bash
          programs.bash.initExtra = ''
            ${shellSetTitleFunctions}
            trap set_term_title DEBUG
          '';

          # config.programs.zsh.initContent;
        }
      )

      (lib.mkIf cfg.enableFancyCtrlZ {
        programs.zsh.initContent = ''
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

    ]
  );

}
