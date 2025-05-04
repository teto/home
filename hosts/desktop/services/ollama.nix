{ config, ... }:
{

  enable = false;

  # start it as teto such that it can find
  user = "teto";

  # user = "ollama";
  group = "users";

  # TODO use config.home.homeDirectory ?
  home = "/home/teto";
  # example = "/path/to/ollama/models";

  # check https://github.com/NixOS/nixpkgs/issues/291217
  acceleration = "cuda";
  # folders where to find models:
  # Default: "\${config.services.ollama.home}/models"
  # models = "/mnt/ext/ollama/models";
  # models = "/home/teto/.ollama/models";
  # user = "teto;
  # package
  # Ollama binds to 127.0.0.1 port 11434 by default.
  # Change the bind address with the OLLAMA_HOST

  # list of models https://ollama.ai/library
  # curl http://127.0.0.1:11434/api/tags to list models

  # OLLAMA_MODELS to help it find models
  _imports = [
    # TODO add bindPaths ?
    # serviceConfig.BindPaths = "/run/mysqld";
    ({
      # systemd.services.ollama.serviceConfig.BindPaths =
      #   "/home/teto/.ollama/models:/var/lib/ollama/models";

    })

  ];

}
