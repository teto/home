with import <nixpkgs> {};

let
    # neovim-dev-clang = (self.neovim-dev.override {
    # stdenv = super.clangStdenv;
  # }).overrideAttrs(oa:{
    # shellHook = oa.shellHook + ''
    #   export CLANG_SANITIZER=ASAN_UBSAN
    # '';
  # });

  neovim-dev = (neovim-unwrapped.override  {
    doCheck=true;
    devMode=true;
    stdenv = clangStdenv;
  }).overrideAttrs(oa:{
    cmakeBuildType="debug";
    cmakeFlags = oa.cmakeFlags ++ [ "-DMIN_LOG_LEVEL=0" ];

      # preConfigure= ''
      #   export NIX_LDFLAGS="$NIX_LDFLAGS -rpath /home/teto/libtermkey/build/lib"
      # '';

      # postConfigure = ''
      #   echo "Postconfigure: $PKG_CONFIG_PATH"
      # '';

      # cmakeFlags = oa.cmakeFlags
      # ++ [
      #   "-DLIBTERMKEY_INCLUDE_DIR=/home/teto/libtermkey/build/include"
      #   "-DLIBTERMKEY_LIBRARY=/home/teto/libtermkey/build/lib/libtermkey.so"
      # ];


      version = "master";
      src = builtins.fetchGit {
        url = https://github.com/neovim/neovim.git;
      };


      # buildInputs = libtermkey

      nativeBuildInputs = oa.nativeBuildInputs ++ [
        valgrind
        ccls
      ];

    buildInputs = oa.buildInputs ++ [
      # certainly a termporary change
      utf8proc
    ];

    # checkInputs = 
    postConfigure = ''
      ln -s compile_commands.json ..
    '';

    shellHook = ''
      export NVIM_PYTHON_LOG_LEVEL=DEBUG
      export NVIM_LOG_FILE=/tmp/log
      # export NVIM_PYTHON_LOG_FILE=/tmp/log
      export VALGRIND_LOG="$PWD/valgrind.log"

      echo "To run tests:"
      echo "VALGRIND=1 TEST_FILE=test/functional/core/job_spec.lua TEST_TAG=env make functionaltest"

    '';
  });
in
  neovim-dev
