{ pkgs, lib, ... }:
{
  environment.systemPackages = [
    pkgs.docling
    pkgs.docling-serve
  ];

  services.docling-serve = {
    enable = true;
    openFirewall = true;
    # the module prepends HF_HOME/EASYOCR_MODULE_PATH/MPLCONFIGDIR = "."
    environment = {
      DOCLING_SERVE_ENABLE_UI = "True";
      # docling's AcceleratorOptions reads DOCLING_* env vars (auto|cpu|cuda|mps)
      DOCLING_DEVICE = "cuda";
    };
  };

  # The upstream module hardens the unit with DevicePolicy=closed, which hides
  # /dev/nvidia* from the process => torch silently falls back to CPU.
  # Whitelist the nvidia character devices (classes from /proc/devices).
  systemd.services.docling-serve.serviceConfig = {
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
