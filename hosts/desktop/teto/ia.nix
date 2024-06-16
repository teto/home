{
  config,
  lib,
  pkgs,
  flakeInputs,
  ...
}:
{
  imports = [
    # ../../../hm/modules/local-ai.nix
  ];

  home.packages =
    with pkgs;
    let
      my-local-ai = (
        local-ai-teto.override ({
          # with_cublas = true;
          with_tts = false;
        })
      );
    in
    [
      # whisper-cpp broken
      # local-ai-teto
      # my-local-ai
      llama-cpp # to test
      # llm-ls # needed by the neovim plugin
      # from overlay
      # ollamagpu # st config.withCuda to enable 

      # broken
      # flakeInputs.localai.packages.${pkgs.system}.local-ai-cublas #cublas is the cuda version
    ];

  # services.local-ai.enable = true;
}
