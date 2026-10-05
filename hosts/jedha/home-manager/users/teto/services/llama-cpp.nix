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

      # since we expose it via nginx
      # _outbound
      host = "127.0.0.1";
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

      host = "127.0.0.1";

    };
  };
}
