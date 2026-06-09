{
  secrets,
  pkgs,
  # flakeSelf,
  ...
}:
let
  configFormat = pkgs.formats.ini { };

in
{

  # imports = [
  # flakeSelf.nixosProfiles.llama-cpp
  # ];

  enable = true;
  openFirewall = true;
  host = "0.0.0.0";

  settings = {
    port = 8888; # to avoid conflict with headscale
    models-preset = configFormat.generate "models-preset.ini" {
      "Qwen3-Coder-Next" = {
        hf-repo = "unsloth/Qwen3-Coder-Next-GGUF";
        hf-file = "Qwen3-Coder-Next-UD-Q4_K_XL.gguf";
        # we can create an alias
        alias = "unsloth/Qwen3-Coder-Next";
        # fit = "on";
        # seed = "3407";
        # temp = "1.0";
        # top-p = "0.95";
        # min-p = "0.01";
        # top-k = "40";
        jinja = "on";
      };
    };
    "api-key" = secrets.jakku.llama.api-key;

  };
}
