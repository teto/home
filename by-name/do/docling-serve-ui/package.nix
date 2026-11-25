# nixpkgs only builds the python side; the web UI is a separate vite/react
# app in ui/ that upstream builds into docling_serve/ui_static. Without it
# DOCLING_SERVE_ENABLE_UI=True just logs "UI bundle was not found" and /ui 404s.
{
  buildNpmPackage,
  docling-serve,
}:
buildNpmPackage {
  pname = "docling-serve-ui";
  inherit (docling-serve) version src;
  sourceRoot = "${docling-serve.src.name}/ui";
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
}
