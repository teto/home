{ pkgs, ...}:
{
  services.ollama = {
    enable = false;
    # acceleration = "cuda";
    # pkgs.ollama[,-vulkan,-rocm,-cuda,-cpu]`
    package = pkgs.ollama-cuda;
    port = 11434;
  };
  # OLLAMA_KEEP_ALIVE The duration that models stay loaded in memory (default is "5m")
  # acceleration = "nvidia";

}
