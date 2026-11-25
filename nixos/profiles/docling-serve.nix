{ pkgs, lib, config, ... }:
let 
  DOCLING_SERVE_CONFIG_FILE = toString (pkgs.writeText "docling-serve.json" (builtins.toJSON {
    default_vlm_preset = "local_llm";
    # custom_vlm_presets.local_llm = {
    #   model_spec = {
    #     name = "Granite-Docling via vLLM";
    #     default_repo_id = "ibm-granite/granite-docling-258M";
    #     prompt = "Convert this page to docling.";
    #     response_format = "doctags";   # or "markdown" for a generic VLM
    #   };
    #   engine_options = {
    #     engine_type = "api";
    #     url = "http://localhost:8000/v1/chat/completions";
    #     params = { model = "ibm-granite/granite-docling-258M"; max_tokens = 4096; };
    #     timeout = 120.0;
    #     concurrency = 4;
    #   };
    #   scale = 2.0;
    # };
  }));

in
{
  environment.systemPackages = [
    pkgs.docling
    pkgs.docling-serve-with-ui
  ];


  # Keep API keys out of this file. Authentication goes in engine_options.headers, and anything in writeText ends up in the world-readable Nix store. Put the preset in an EnvironmentFile instead (for example DOCLING_SERVE_CUSTOM_VLM_PRESETS='{...}' written by agenix or sops). Because environment variables override the config file, the rest of the settings can stay in Nix.
  # 

  services.docling-serve = {
    enable = true;
    host = "0.0.0.0";
    package = pkgs.docling-serve-with-ui;
    openFirewall = true;
    # the module prepends HF_HOME/EASYOCR_MODULE_PATH/MPLCONFIGDIR = "."
    environment = {
      DOCLING_SERVE_ENABLE_UI = "True";
      # docling's AcceleratorOptions reads DOCLING_* env vars (auto|cpu|cuda|mps)
      # DOCLING_DEVICE = "cuda";
      DOCLING_SERVE_ENABLE_REMOTE_SERVICES = "True";
      inherit  DOCLING_SERVE_CONFIG_FILE;
    };
  };

  # The upstream module hardens the unit with DevicePolicy=closed, which hides
  # /dev/nvidia* from the process => torch silently falls back to CPU.
  # Whitelist the nvidia character devices (classes from /proc/devices).
  systemd.services.docling-serve.serviceConfig = let 
      cfg = config.services.docling-serve;
  in {

    # TODO create --artifacts-path to avoid several redownloads
    # --enable-ui --artifacts-path
    ExecStart = lib.mkForce "${lib.getExe cfg.package} run --host \"${cfg.host}\" --port ${toString cfg.port} --enable-ui ";


    # could replace Exec with --enable-ui
    DeviceAllow = [
      "char-nvidia rw" # major 195: /dev/nvidia0, nvidiactl, nvidia-modeset
      "char-nvidia-uvm rw" # CUDA unified memory, required by torch
      "char-nvidia-caps rw"
      "/dev/dxg rw" # WSL2 GPU paravirtualization (DirectX kernel interface)
    ];
    # PrivateUsers remaps uids, which can break access to the driver nodes
    PrivateUsers = lib.mkForce false;
  };
}
