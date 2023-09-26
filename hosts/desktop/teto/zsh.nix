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
   };
  };
}
