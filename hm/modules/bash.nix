{ config, lib, pkgs, flakeInputs, ... }:

with lib;

let
  cfg = config.programs.bash;

  termTitleSubmodule = types.submodule (import ./title-submodule.nix);
in 
 {
  options = {
    programs.bash = {
      # enableFzfGit = mkEnableOption "Fzf-git";
      # enableVocageSensei = mkEnableOption "Vocage sensei";

      termTitle = mkOption {
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

  config = mkIf cfg.enable (mkMerge [

    # (mkIf cfg.enableFzfGit {
	 # programs.bash.initExtra =
		# ''
		# source ${fzf-git-sh}/fzf-git.sh
		# '';
    # })

    (let 
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

     in mkIf cfg.termTitle.enable {

      # depending 
      # in my case since I am using starship
      # https://starship.rs/advanced-config/#custom-pre-prompt-and-pre-execution-commands-in-bash
      programs.bash.initExtra =  ''
        ${shellSetTitleFunctions}
        trap set_term_title DEBUG
        '';
    })
  ]);
 }
