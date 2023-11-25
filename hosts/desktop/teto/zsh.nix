{ config, pkgs, lib
, secrets
, withSecrets
, ... }:
{
  imports = [
   ../../../hm/profiles/zsh.nix
   # ../../profiles/bash.nix
  ];

  xdg.configFile."zsh/zshrc.generated".source = ../../../config/zsh/zshrc;


  # TODO prefix withg zsh
   programs.zsh = {

    sessionVariables = config.programs.bash.sessionVariables // 
     lib.optionalAttrs withSecrets {
     # HISTFILE="$XDG_CACHE_HOME/zsh_history";
     # TODO load this from sops instead
     GITHUB_TOKEN = secrets.githubToken;
     # TODO add it to sops
     OPENAI_API_KEY = secrets.OPENAI_API_KEY;
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
     '';

  };


  # for programs not merged yet
  home.packages = with pkgs; [
   # ironbar 
	# haxe # to test https://neovim.discourse.group/t/presenting-haxe-neovim-a-new-toolchain-to-build-neovim-plugins/3720
    # meli  # broken jmap mailreader

    fre
  ];

}
