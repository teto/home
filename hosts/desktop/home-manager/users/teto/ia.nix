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
      # flakeInputs.localai.packages.${pkgs.system}.local-ai-cublas #cublas is the cuda version
      # whisper-cpp broken
      my-local-ai = (
        local-ai-teto.override ({
          # with_cublas = true;
          with_tts = false;
        })
      );
    in
    [
      # my-local-ai
      # llama-cpp # to test
      llama-cpp-matt # simpler than
    ];

  # services.local-ai.enable = true;
}
