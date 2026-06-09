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
    # model = "/home/teto/llama-models/mistral-7b-openorca.Q6_K.gguf";
    extraFlags = [
      # to allow devtools calls
      # "--jinja" # it is the default
      "--model-presets contrib/llama-presets.ini"
    ];
    host = "0.0.0.0";
    # modelsPreset = {
    # "Qwen3-Coder-Next" = {
    #   hf-repo = "unsloth/Qwen3-Coder-Next-GGUF";
    #   hf-file = "Qwen3-Coder-Next-UD-Q4_K_XL.gguf";
    #   alias = "unsloth/Qwen3-Coder-Next";
    #   fit = "on";
    #   seed = "3407";
    #   temp = "1.0";
    #   top-p = "0.95";
    #   min-p = "0.01";
    #   top-k = "40";
    #   jinja = "on";
    # };
    # };

  };
}
