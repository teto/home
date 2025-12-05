{ config, lib, pkgs, ... }:
{
  
  # actually accessed via llama-swap instead ?
  services.llama-cpp = {

    enable = false;
    model = "/home/teto/llama-models/mistral-7b-openorca.Q6_K.gguf";

  };
}
