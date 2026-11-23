{ pkgs, lib, ... }:
let
  # nixpkgs only builds the python side; the web UI is a separate vite/react
  # app in ui/ that upstream builds into docling_serve/ui_static. Without it
  # DOCLING_SERVE_ENABLE_UI=True just logs "UI bundle was not found" and /ui 404s.
  docling-serve-ui = pkgs.buildNpmPackage {
    pname = "docling-serve-ui";
    inherit (pkgs.docling-serve) version src;
    sourceRoot = "${pkgs.docling-serve.src.name}/ui";
    npmDepsHash = "sha256-lEKhwvkVMGuMVjk87/u19ridN/dQnFRh+I9G6s4eMBQ=";

    # vite.config.ts writes to ../docling_serve/ui_static, which is outside the
    # writable sourceRoot: redirect to a local dir (appended to `vite build`)
    npmBuildFlags = [
      "--"
      "--outDir"
      "dist"
    ];

    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';
  };

  docling-serve-with-ui = pkgs.docling-serve.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      # glob the existing package dir (stdenv uses nullglob, so a glob on the
      # not-yet-existing ui_static would expand to nothing)
      for d in $out/lib/python3*/site-packages/docling_serve; do
        cp -r ${docling-serve-ui} "$d/ui_static"
      done
    '';
  });
in
{
  environment.systemPackages = [
    pkgs.docling
    docling-serve-with-ui
  ];

  services.docling-serve = {
    enable = true;
    package = docling-serve-with-ui;
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
