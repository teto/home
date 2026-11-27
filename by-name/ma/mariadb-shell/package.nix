{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  krb5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mariadb-shell";
  version = "26.11.0";

  src = fetchurl {
    url = "https://github.com/mariadb-corporation/mariadb-shell/releases/download/v${finalAttrs.version}/mariadb-shell-${finalAttrs.version}-linux-glibc2.34-x86-64bit.tar.gz";
    hash = "sha256-572KGORM4/BrFMHDoWC3lMDrC46FrMWaK2dP3dncOU0=";
  };

  sourceRoot = "mariadb-shell-${finalAttrs.version}-linux-glibc2.34-x86-64bit";

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    krb5
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp -a . "$out/"
    runHook postInstall
  '';

  meta = {
    description = "Advanced client and code editor for MariaDB";
    homepage = "https://github.com/mariadb-corporation/mariadb-shell";
    license = lib.licenses.gpl2Only;
    mainProgram = "mariadb-shell";
    platforms = [ "x86_64-linux" ];
  };
})
