with import <nixpkgs> {};

let
    # neovim-dev-clang = (self.neovim-dev.override {
    # stdenv = super.clangStdenv;
  # }).overrideAttrs(oa:{
    # shellHook = oa.shellHook + ''
    #   export CLANG_SANITIZER=ASAN_UBSAN
    # '';
  # });

      # cmakeFlags = oa.cmakeFlags
      # ++ [
      #   "-DLIBTERMKEY_INCLUDE_DIR=/home/teto/libtermkey/build/include"
      #   "-DLIBTERMKEY_LIBRARY=/home/teto/libtermkey/build/lib/libtermkey.so"
      # ];

    postConfigure = ''
      ln -s compile_commands.json ..
    '';

in
  neovim-dev
