self: super:
{


  neovim-unwrapped = super.pkgs.neovim-unwrapped.override({

  });

  # TODO do a version with clang
  neovim-dev = (super.pkgs.neovim-unwrapped.override  {
    # name = "neovim-test";
    doCheck=true;
  }).overrideAttrs(oa:{
    cmakeBuildType="debug";
      # -DMN_LOG_LEVEL

    nativeBuildInputs = oa.nativeBuildInputs ++ [ self.pkgs.valgrind ];
    shellHook = ''
      export NVIM_PYTHON_LOG_LEVEL=DEBUG
      export NVIM_LOG_FILE=/tmp/log
      # export NVIM_PYTHON_LOG_FILE=/tmp/log
      export VALGRIND_LOG="$PWD/valgrind.log"

      echo "To run tests:"
      echo "VALGRIND=1 TEST_FILE=test/functional/core/job_spec.lua TEST_TAG=env make functionaltest"
    '';
  });

  neovim-dev-clang = (self.neovim-dev.override { 
    stdenv = super.clangStdenv;
  }).overrideAttrs(oa:{
    shellHook = oa.shellHook + ''
      export CLANG_SANITIZER=ASAN_UBSAN
    '';
  });

  #     # withPython = false;
  #     # withPython3 = false; # pour les tests ?
  #     # withRuby = false; # pour les tests ?
  #     # extraPython3Packages = with self.python3Packages;[ pandas python jedi]
  #     # ++ super.stdenv.lib.optionals ( self.pkgs ? python-language-server) [ self.pkgs.python-language-server ] ;
  #     # todo generate a file with the path to python-language-server ?
  #     # unpackPhase = ":"; # cf https://nixos.wiki/wiki/Packaging_Software
	  # src = super.lib.cleanSource ~/neovim;
  #     meta.priority=0;
  # });

  # neovim-unwrapped-local = super.pkgs.neovim-unwrapped.overrideAttrs (oldAttrs: {
	  # name = "neovim-unwrapped-local";
	  # src = super.lib.cleanSource ~/neovim;
      # cmakeBuildType="debug";
      # meta.priority=0;
  # });

  # neovim-unwrapped-master = (super.neovim-unwrapped).overrideAttrs (oldAttrs: {
	  # name = "neovim";
	  # version = "nightly";
      # src = self.fetchGitHashless {
      #   rev = "master";
      #   url = "git@github.com:neovim/neovim.git";

      # src = super.fetchFromGitHub {
      #   owner = "neovim";
      #   repo = "neovim";
      #   rev = "674cb2afde0d82557c8e3afdf706cd6f75195fa5";
      #   sha256 = "13cyfvhxjfc3h50vhfdfifi2zxm15w0mda67nxvlj6ksvcjy4020";
      # };
  #     meta.priority=1;
    # });
    # or null;

  }

