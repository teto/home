{
  config,
  lib,
  pkgs,
  flakeSelf,
  ...
}:
{

  home.packages =
    with pkgs;
    let
      # flakeSelf.inputs.localai.packages.${pkgs.stdenv.hostPlatform.system}.local-ai-cublas #cublas is the cuda version
      # whisper-cpp broken
      my-local-ai = (
        local-ai-teto.override ({
          # with_cublas = true;
          with_tts = false;
        })
      );
    in
    [
    ];

  # services.local-ai.enable = true;
}
