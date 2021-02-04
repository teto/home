{ stdenv, lib, fetchFromGitHub, fetchgit, python2, gn, ninja
, fontconfig, expat, icu58, libglvnd, libjpeg, libpng, libwebp, zlib
, mesa, libX11, harfbuzz
}:

stdenv.mkDerivation {
  name = "skia-rust-skia-m71";

  src = fetchFromGitHub {
    owner = "rust-skia";
    repo = "skia";
    rev = "fbf4fc089d823a9fefdaa529ac55625933f23760";
    sha256 = "1i4in5azgqm9ck2mqzbp64hin68a1bv5hwxlbf63s8mz302p9w8d";
  };

  nativeBuildInputs = [ python2 gn ninja];

  buildInputs = [
    fontconfig expat icu58 libglvnd libjpeg libpng libwebp zlib
    mesa libX11 harfbuzz
  ];

  configurePhase = ''
    runHook preConfigure
    mkdir third_party/external
    gn gen out/Release --args="is_debug=false is_official_build=true skia_enable_gpu=true skia_use_gl=false skia_use_system_libjpeg_turbo=true skia_use_system_libpng=true skia_use_system_zlib=true skia_use_xps=false skia_use_dng_sdk=false skia_use_libheif=false skia_enable_vulkan_debug_layers=false skia_enable_atlas_text=false skia_enable_spirv_validation=false skia_enable_tools=false skia_enable_skshaper=true skia_use_icu=true skia_use_system_icu=true skia_use_harfbuzz=true skia_pdf_subset_harfbuzz=true skia_use_system_harfbuzz=true skia_use_sfntly=false skia_enable_skparagraph=true skia_use_expat=true skia_use_system_expat=true skia_use_vulkan=true paragraph_tests_enabled=false extra_cflags=[\"-I${harfbuzz.dev}/include/harfbuzz\"]"
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    ninja -C out/Release skia
    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out

    # Glob will match all subdirs.
    shopt -s globstar

    # All these paths are used in some way when building aseprite.
    cp -r --parents -t $out/ \
      include/codec \
      include/config \
      include/core \
      include/effects \
      include/gpu \
      include/private \
      include/utils \
      out/Release/*.a \
      src/gpu/**/*.h \
  '';
}

