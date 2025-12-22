{ config, lib, pkgs, ... }:
{
  services.llama-cpp = {
  enable = true; 

    extraFlags = [
                  "-c"
                  "4096"
                  "-ngl"
                  "32"
                  "--numa"
                  "numactl"
  ];

  host = "0.0.0.0";
  #model = "/models/mistral-instruct-7b/ggml-model-q4_0.gguf";
  openFirewall = true;

  };
}
