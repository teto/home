with import <nixpkgs> {
  # overlays = [ 
  #   import 
  # ];
};

let
    # neovim-dev-clang = (self.neovim-dev.override {
    # stdenv = super.clangStdenv;
  # }).overrideAttrs(oa:{
    # shellHook = oa.shellHook + ''
    #   export CLANG_SANITIZER=ASAN_UBSAN
    # '';
  # });

  postConfigure = ''
    ln -s compile_commands.json ..
  '';

  nvim-shell-dev = neovim-dev.overrideAttrs(oa: {
	cmakeBuildType="debug";

    # //Flags used by the C compiler during DEBUG builds.
    # CMAKE_C_FLAGS_DEBUG:STRING=-g

    # CMAKE_EXTRA_FLAGS
    cmakeFlags = oa.cmakeFlags ++ [
      "-DMIN_LOG_LEVEL=0"
      "-DENABLE_LTO=OFF"
      "-DUSE_BUNDLED=OFF"
      ''-DCMAKE_C_FLAGS=-gdwarf-2'' #  -g3
      # useful to
      # https://github.com/google/sanitizers/wiki/AddressSanitizerFlags
      # https://clang.llvm.org/docs/AddressSanitizer.html#symbolizing-the-reports
      "-DCLANG_ASAN_UBSAN=ON"
	];

    nativeBuildInputs = oa.nativeBuildInputs ++ [
      # testing between both
      # pkgs.ccls
      pkgs.python-language-server
      pkgs.clang-tools  # for clangd
      pkgs.llvm_11  # for llvm-symbolizer
      # pkgs.valgrind
    ];

    # export NVIM_PROG
    # https://github.com/neovim/neovim/blob/master/test/README.md#configuration
    # b __asan::ReportGenericError
    # TODO export as a neovim debug hook
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
      # ASAN_OPTIONS=halt_on_error=0
      #  ./stderr
      export ASAN_OPTIONS="log_path=./test.log:halt_on_error=0"
      export UBSAN_OPTIONS=print_stacktrace=1

    '';
  });
in
  nvim-shell-dev
