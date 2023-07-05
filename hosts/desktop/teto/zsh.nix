{ config, pkgs, lib, secrets, 
# flakeInputs,
... }:
let
  secrets = import ../../../nixpkgs/secrets.nix;
in
{
  imports = [
   ../../../hm/profiles/zsh.nix
   # ../../profiles/bash.nix
  ];

  # TODO prefix withg zsh
   programs.zsh = {

   sessionVariables = config.programs.bash.sessionVariables // {
     # HISTFILE="$XDG_CACHE_HOME/zsh_history";
     # TODO load this from sops instead
     GITHUB_TOKEN = secrets.githubToken;
     # TODO add it to sops
     OPENAI_API_KEY = secrets.OPENAI_API_KEY;
   };
  };
}
