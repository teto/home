{ config, lib, pkgs, flakeInputs, ... }:
{
  imports = [
              # ../../../hm/modules/local-ai.nix
            ];
 home.packages = with pkgs; let 
  my-local-ai =     (local-ai.override({
   # with_cublas = true;
   with_tts = false;
  }));
  in [
    # whisper-cpp broken
   my-local-ai


    llm-ls # needed by the neovim plugin
    # from overlay
    # ollamagpu # st config.withCuda to enable 

    # broken
    # flakeInputs.localai.packages.${pkgs.system}.local-ai-cublas #cublas is the cuda version
   ];


  # services.local-ai.enable = true;

  home.sessionVariables = {
    MODELS_PATH= "/home/teto/localai-models";
    LOCALAI_CONFIG_DIR= "/home/teto/.config/localai";

  # Usage:   "A List of models to apply in JSON at start",
  # EnvVars: []string{"PRELOAD_MODELS"},
  };

  # services.local-ai.enable = true;

}
