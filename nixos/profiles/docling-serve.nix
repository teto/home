{ pkgs, lib, config, ... }:
{
  environment.systemPackages = [
    pkgs.docling
    pkgs.docling-serve-with-ui
  ];

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
