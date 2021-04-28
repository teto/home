{ rustPlatform
, fetchurl
, fetchFromGitHub
, defaultCrateOverrides
, callPackage
, lib

, cmake
, cacert
, pkg-config
, fontconfig
, cargo
, rustc
, python
, llvmPackages_latest
, vulkan-tools
, xorg
, xorg_sys_opengl
, libglvnd
, freeglut
, patchelf
, makeFontsConf
, freefont_ttf

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
    xorg.libXcursor
    xorg.libXext
    xorg.libXrandr
    xorg.libXi
    fontconfig
  ];
  # patchelf --set-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/alacritty
in rustPlatform.buildRustPackage rec {
  pname = "neovide";
  version = "0.7.1";
  src = fetchFromGitHub {
    owner = "Kethku";
    repo = "neovide";
    rev = "e1d8d404167f5c6d5471ce1404493eb1805e94d2";
    sha256 = "sha256-j0NfzfaqRiFXE47gcPiv9AIBuzICrY/1YWjQ8TUm0RA=";
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
  cargoSha256 = "sha256-u1Qmr8vOQ6+RCy6T9Un011Nl6FBfOmoWRdqyOSPcCG0=";

  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };

  SSL_CERT_FILE = "${cacert.out}/etc/ssl/certs/ca-bundle.crt";
  CURL_CA_BUNDLE = "${cacert.out}/etc/ssl/certs/ca-bundle.crt";
  nativeBuildInputs = [
    cacert
    cmake
    pkg-config
    cargo
    rustc
    python
    vulkan-tools
    patchelf
    xorg.libXext.dev # for xext.h
    # xorg.libXcursor
  ] ++ (with llvmPackages_latest; [
    clang
    llvm
  ]);
  buildInputs = [
    xorg.libXext.dev # for xext.h
    skia
    expat
    openssl
    SDL2
    vulkan-loader
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    freetype
    # fontconfig
    # xorg_sys_opengl
    # libglvnd
    # freeglut
    # freeglut.dev
  ];


  # :${xorg.libXcursor}/lib"
  #     export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${vulkan-loader}/lib"
  shellHook = ''

    echo 'patchelf --set-rpath "${lib.makeLibraryPath rpathLibs}" target/debug/neovide'
  '';
}

