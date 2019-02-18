self: super:
let
  startPlugins = with super.pkgs.vimPlugins; [
            fugitive
            vimtex
            # replaced by ale ?
            LanguageClient-neovim
            vim-signify
            vim-startify
            vim-scriptease
            vim-grepper
            vim-nix
            vim-obsession
            # deoplete-khard
            # TODO this one will be ok once we patch it
            # vim-markdown-composer  # WIP
# vim-highlightedyank
        ];

in
{

  neovim-unwrapped-master = (super.neovim-unwrapped).overrideAttrs (oldAttrs: {
	  name = "neovim";
	  version = "nightly";

      src = builtins.fetchGit {
        # url = git@github.com:neovim/neovim.git;
        url = https://github.com/neovim/neovim.git;
        # ref = "master";
        # rev = "";
      };

  });

  neovim-unwrapped-float = (super.neovim-unwrapped).overrideAttrs (oldAttrs: {
	  name = "neovim";
	  version = "float";

      src = builtins.fetchGit {
        # url = git@github.com:neovim/neovim.git;
        url = https://github.com/neovim/neovim.git;
        ref = "+refs/pull/6619/head";
        # ref = "master";
        # rev = "";
      };
  });


  # neovim-unwrapped = self.neovim-unwrapped-master;

  # test on nixos unstable
  neovim-test = super.neovim.override {
          # extraPython3Packages withPython3
          # extraPythonPackages withPython
          # withNodeJs withRuby 
          viAlias=false;
          vimAlias=true;
          # configure;
  };

  neovimHaskellConfig = {

    withHaskell = true;
    # haskellPackages = [
          # hie
    #   haskellPackages.haskdogs # seems to build on hasktags/ recursively import things
    #   haskellPackages.hasktags
    #   haskellPackages.nvim-hs
    #   haskellPackages.nvim-hs-ghcid
    # ];
    # customRC = ''
    #     let g:LanguageClient_serverCommands = {
    #       'haskell': ['hie', '--lsp', '-d', '--logfile', '/tmp/lsp_haskell.log' ]
    #     }
    #   '';

  };

  neovimDefaultConfig = {
        withPython3 = true;
        withPython = false;
        withRuby = true; # for vim-rfc/GhDashboard etc.
        customRC = ''
          " always see at least 10 lines
          set scrolloff=10
          set hidden

        " Failed to start language server: No such file or directory: 'pyls'
        " todo do the same for pyls/vimtex etc
        let g:vimtex_compiler_latexmk = {}
        " latexmk is not in combined.small/basic
        " vimtex won't let us setup paths to bibtex etc, we can do it in .latexmk ?

        let g:LanguageClient_serverCommands = {
             \ 'python': [ fnamemodify( g:python3_host_prog, ':p:h').'/pyls', '-vv', '--log-file' , '/tmp/lsp_python.log']
             \ , 'haskell': ['hie-wrapper', '--lsp', '-d', '--vomit', '--logfile', '/tmp/lsp_haskell.log' ]
             \ , 'cpp': ['${super.pkgs.cquery}/bin/cquery', '--log-file=/tmp/cq.log']
             \ , 'c': ['${super.pkgs.cquery}/bin/cquery', '--log-file=/tmp/cq.log']
             \ }

        let g:neomake_python_mypy_exe = fnamemodify( g:python3_host_prog, ':p:h').'/mypy'

        autocmd BufReadPost *.pdf silent %!${self.pkgs.xpdf}/bin/pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78
        ''
        ;

    configure = {
        packages.myVimPackage = {
          # see examples below how to use custom packages
          # loaded on launch
          start = startPlugins;
          # manually loadable by calling `:packadd $plugin-name`
          opt = [ ];
        };
      };

    extraPython3Packages = ps: with ps; [
      pandas
      jedi
      urllib3 
      # pygments # for pygmentize and minted in latex
      mypy
      pyls-mypy # on le desactive sinon il genere des
      python-language-server
      pycodestyle
    ]
      # ++ lib.optionals ( pkgs ? pyls-mypy) [ pyls-mypy ]
    ;

  };


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

  }

