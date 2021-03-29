{ rustPlatform
, fetchurl
, fetchFromGitHub
, defaultCrateOverrides
, callPackage
, lib

, cmake
, cacert
, pkgconfig
, fontconfig
, cargo
, rustc
, python
, llvmPackages_latest
, vulkan-tools
, xlibs
, xorg
, xorg_sys_opengl
, libglvnd
, freeglut
, patchelf

, expat
, openssl
, freetype
, harfbuzz
, icu
, libjpeg_turbo
, libpng
, zlib
, SDL2
, vulkan-loader
}:
let
  skia = callPackage ./skia.nix {};
  # https://github.com/Kethku/neovide/issues/465
  rpathLibs = [
    libglvnd
    freeglut
    freeglut.dev
    freetype

    vulkan-loader
    xlibs.libXcursor
    xlibs.libXext
    xlibs.libXrandr
    xorg.libXi
    fontconfig
  ];
  # patchelf --set-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/alacritty
in rustPlatform.buildRustPackage rec {
  pname = "neovide";
  version = "0.7.0";
  src = fetchFromGitHub {
    owner = "Kethku";
    repo = "neovide";
    rev = version;
    sha256 = "sha256-G99rVRcm3ulkt+dlE8VMo0SQmHuuBqPyU7OSycpqrPo=";
    # lib.fakeSha256;

  };
  # src = builtins.filterSource
  #   (path: type:
  #     type == "directory"
  #     || lib.strings.hasSuffix ".rs" path
  #     || lib.strings.hasSuffix ".h" path
  #     || lib.strings.hasSuffix ".cpp" path
  #     || lib.strings.hasSuffix ".toml" path
  #     || lib.strings.hasSuffix ".lock" path
  #     || lib.strings.hasSuffix ".otf" path
  #     || lib.strings.hasSuffix ".desktop" path
  #     || lib.strings.hasSuffix ".ico" path
  #   )
  #   ./.;
  # cargoSha256 = "0qkililxcwjhsvk354ly0bz1gxfqa65ka66f3zri85n3gr9fr397";
  cargoSha256 = "sha256-vOBgAlLkLw8VrDngdQJ8/pIDZq9vtgZIX7nFEJYhHL4=";

  SSL_CERT_FILE = "${cacert.out}/etc/ssl/certs/ca-bundle.crt";
  CURL_CA_BUNDLE = "${cacert.out}/etc/ssl/certs/ca-bundle.crt";
  nativeBuildInputs = [
    cacert
    cmake
    pkgconfig
    cargo
    rustc
    python
    vulkan-tools
    patchelf
    xlibs.libXext.dev # for xext.h
    # xlibs.libXcursor
  ] ++ (with llvmPackages_latest; [
    clang
    llvm
  ]);
  buildInputs = [
    xlibs.libXext.dev # for xext.h
    skia
    expat
    openssl
    SDL2
    vulkan-loader
    xlibs.libXcursor
    xlibs.libXrandr
    xorg.libXi
    freetype
    # fontconfig
    # xorg_sys_opengl
    # libglvnd
    # freeglut
    # freeglut.dev
  ];


  # :${xlibs.libXcursor}/lib"
  #     export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${vulkan-loader}/lib"
  shellHook = ''

    echo 'patchelf --set-rpath "${lib.makeLibraryPath rpathLibs}" target/debug/neovide'
  '';
}

