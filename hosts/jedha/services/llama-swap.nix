{
  pkgs,
  lib,
  ...
}:
{

  # TODO fix ports
  enable = true;

  # else I end up with
  # "The option `services.llama-swap.settings' was accessed but has no value defined. Try setting the option."
  settings =
    let
      # set in teto/default.nix LLM_LOCAL_PORT
      PORT = "11111";
      llama-cpp = pkgs.llama-cpp;
      # .override { rocmSupport = true; };
      llama-server = lib.getExe' llama-cpp "llama-server";

      llama-models = "/home/teto/llama-models";
    in
    {
      healthCheckTimeout = 60;
      models = {
        "some-model" = {
          # Error loading config: model some-model: proxy uses ${PORT} but cmd does not - ${PORT} is only available when used in cmd
          cmd = "${llama-server} --port \${PORT} ${llama-models}/Llama3.2-3B-Esper2.Q4_K_M.gguf -ngl 0 --no-webui";
          aliases = [
            "the-best"
          ];
        };
        # "other-model" = {
        #   proxy = "http://127.0.0.1:5555";
        #   cmd = "${llama-server} --port 5555 -m /var/lib/llama-cpp/models/other-model.gguf -ngl 0 -c 4096 -np 4 --no-webui";
        #   concurrencyLimit = 4;
        # };
      };
    };

}
