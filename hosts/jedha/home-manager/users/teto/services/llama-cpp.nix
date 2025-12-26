{
  config,
  lib,
  pkgs,
  ...
}:
{

  # actually accessed via llama-swap instead ?
  services.llama-cpp = {

    enable = true;
    # package = pkgs.llama-cpp-matt;
    # -m,    --model FNAME                    model path (default: `models/$filename` with filename from `--hf-file`
    #                                         or `--model-url` if set, otherwise models/7B/ggml-model-f16.gguf)
    #                                         (env: LLAMA_ARG_MODEL)
    # -mu,   --model-url MODEL_URL            model download url (default: unused)
    # /home/teto/llama-models/

    # absolute path expected
    # maybe we shouldn't do this as --fim-qwen-3b-default
    model = "/home/teto/llama-models/mistral-7b-openorca.Q6_K.gguf";
    extraFlags = [
      # to allow devtools calls
      "--jinja"
    ];
    host = "0.0.0.0";

  };
}
