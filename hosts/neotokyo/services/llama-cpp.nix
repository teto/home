{ config, lib, pkgs, secrets, ... }:
{
  services.llama-cpp = {
    enable = false; 

  #       "--api-key-file"

    extraFlags = [
      # Load and run the model:
      # the service doesnt like to be started with `-hf`
      "-hf unsloth/functiongemma-270m-it-GGUF:BF16"
      "--api-key ${secrets.jakku.llama-api-key}"
      "-c"
      "4096"
      "-ngl"
      "32"
      "--numa"
      "numactl"
  ];

  host = "0.0.0.0";
  # TODO use a hugging-face url
  # model = "/models/mistral-instruct-7b/ggml-model-q4_0.gguf";
  openFirewall = true;

  };
}
