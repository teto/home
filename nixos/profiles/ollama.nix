{ config, lib, pkgs, ... }:
{

 # https://github.com/jmorganca/ollama/blob/main/docs/faq.md#how-can-i-expose-ollama-on-my-network
 services.ollama = {


   # enable = true;
   # package 
   # Ollama binds to 127.0.0.1 port 11434 by default. 
   # Change the bind address with the OLLAMA_HOST

   # list of models https://ollama.ai/library
   # curl http://127.0.0.1:11434/api/tags to list models


   # OLLAMA_MODELS to help it find models
 };
}
