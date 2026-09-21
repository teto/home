{
  # config,
  # lib,
  pkgs,
  dotfilesPath,
  ...
}:
let
  llama-cuda = pkgs.llama-cpp.override {
    cudaSupport = true;
  };
in
{

  # actually accessed via llama-swap instead ?
  services.llama-cpp.instances = {

    default = {

      enable = true;
      createFishAbbr = true;
      package = llama-cuda;
      port = 9931;
      extraFlags = [
        "-v"
        "--models-preset"
        "${dotfilesPath}/contrib/llama-presets.ini"
      ];

      host = "0.0.0.0";
    };

    embedding = {
      enable = true;
      createFishAbbr = true;
      port = 9932;
      package = llama-cuda;
      extraFlags = [
        "--models-preset"
        "${dotfilesPath}/contrib/llama-embed.ini"
      ];

      host = "0.0.0.0";

    };
  };
}
