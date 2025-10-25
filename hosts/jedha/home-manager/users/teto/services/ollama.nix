{
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    port = 11434;
  };
  # OLLAMA_KEEP_ALIVE The duration that models stay loaded in memory (default is "5m")
  # acceleration = "nvidia";

}
