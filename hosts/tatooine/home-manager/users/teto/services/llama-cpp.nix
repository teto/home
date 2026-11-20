{
  pkgs,
  dotfilesPath,
  ...
}:
{

  # actually accessed via llama-swap instead ?
  services.llama-cpp.instances = {

    default = {

      enable = true;
      createFishAbbr = true;
      package = pkgs.llama-cpp;
      port = 9931;
      extraFlags = [
        "-v"
        # load generic defaults from ~/.config/llama.cpp/config.ini
        # but per-model is at
        "--models-preset"
        # could be xdgConfig
        "${dotfilesPath}/config/llama.cpp/presets.ini"
      ];

      # since we expose it via nginx
      # _outbound
      host = "127.0.0.1";
    };

    embedding = {
      enable = true;
      createFishAbbr = true;
      port = 9932;
      package = pkgs.llama-cpp;
      extraFlags = [
        "--models-preset"
        "${dotfilesPath}/contrib/llama-embed.ini"
      ];

      host = "127.0.0.1";

    };
  };
}

