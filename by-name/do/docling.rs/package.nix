{
  lib,
  fetchFromGitHub,
  ffmpeg-headless,
  makeWrapper,
  oniguruma,
  onnxruntime,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "docling-rs";
  version = "2.88.0";

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling.rs";
    rev = "708c7399ae7f6ae9cc1c532d2a87247a03db0787";
    hash = "sha256-j7DgRyfGRtWQS2VHaI+LsanVq/hHegHP+y/fF7egyK8=";
  };

  cargoLock.lockFile = "${src}/Cargo.lock";

  cargoBuildFlags = [ "-p" "docling-cli" ];
  buildFeatures = [ "ort-load-dynamic" "serve" ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    oniguruma
    openssl
  ];

  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/docling-rs \
      --set-default ORT_DYLIB_PATH "${onnxruntime}/lib/libonnxruntime${stdenv.hostPlatform.extensions.sharedLibrary}" \
      --prefix PATH : "${lib.makeBinPath [ ffmpeg-headless ]}"
  '';

  meta = {
    description = "Rust port of docling for document conversion";
    homepage = "https://github.com/docling-project/docling.rs";
    license = lib.licenses.mit;
    mainProgram = "docling-rs";
    platforms = lib.platforms.unix;
  };
}
