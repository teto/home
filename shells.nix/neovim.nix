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

  nvim-shell-dev = neovim-dev.overrideAttrs(oa: {
	cmakeBuildType="debug";

    cmakeFlags = oa.cmakeFlags ++ [
      "-DMIN_LOG_LEVEL=0"
      # useful to
      # "-DCLANG_ASAN_UBSAN=ON"
	];

    nativeBuildInputs = oa.nativeBuildInputs ++ [
      # testing between both
      pkgs.ccls
      # pkgs.clang-tools  # for clangd
      # pkgs.llvm  # for llvm-symbolizer
      # pkgs.valgrind
    ];

    # export NVIM_PROG
    # https://github.com/neovim/neovim/blob/master/test/README.md#configuration
    shellHook = oa.shellHook + ''
      export NVIM_PYTHON_LOG_LEVEL=DEBUG
      export NVIM_LOG_FILE=/tmp/log
      # export NVIM_PYTHON_LOG_FILE=/tmp/log
      export VALGRIND_LOG="$PWD/valgrind.log"

      export NVIM_TEST_PRINT_I=1
      export NVIM_TEST_MAIN_CDEFS=1
      echo "echo getpid()"
      echo "To run tests:"
      echo "test/functional/fswatch/fswatch_spec.lua"
      echo "VALGRIND=1 TEST_FILE=test/functional/core/job_spec.lua TEST_TAG=env make functionaltest"
    '';

  });

in
  nvim-shell-dev
