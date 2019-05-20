self: super:
let
  startPlugins = with super.pkgs.vimPlugins; [
      # echodoc-vim
      # 
# Plug 'deoplete-plugins/deoplete-zsh'
# Plug 'deoplete-plugins/deoplete-jedi'
      csv-vim
      deoplete-nvim
      # deoplete-jedi # keeps crashing
      # deoplete-zsh # not available just yet
      # echodoc-vim
      fugitive
      far-vim

      # fails with   python module. Run `pip install neovim` to fix. For more info, :he nvim-python"
      # floobits-neovim

      fzf-vim
      # defined in overrides: TODO this should be easier: like fzf-vim should be enough
      fzfWrapper

      # replaced by ale ?
      LanguageClient-neovim
      tagbar
      # targets-vim
      # vCoolor-vim
      vim-dirvish
      vim-fugitive
      vim-signature
      vim-signify
      vim-startify
      vim-scriptease
      vim-sneak
      vim-grepper
      vim-nix
      vim-obsession
      vim-rsi
      vim-sayonara
      # deoplete-khard
      # TODO this one will be ok once we patch it
      # vim-markdown-composer  # WIP
      vim-markdown-preview  # WIP
      vim-highlightedyank
      vim-commentary

      # vimwiki

      # reuse once https://github.com/neovim/neovim/issues/9390 is fixed
      # vimtex
      ultisnips 
      unicode-vim
    ];


in
rec {
  /* for compatibility with passing extraPythonPackages as a list; added 2018-07-11 */
  compatFun = funOrList: (if builtins.isList funOrList then (_: funOrList) else funOrList);

  # this generates a config appropriate to work with the passed derivations
  # for instance to develop on a software from a nix-shell
  genNeovim = drvs: userConfig:
    with super;
    let
      # isHaskellPkg
      # lib.debug.traceVal
      requiredPythonModules =  (super.python3Packages.requiredPythonModules drvs);

      # Get list of required Python modules given a list of derivations.
      # TODO look into compiler.shellFor { packages= } to see how to get deps
      # from pkgs/development/haskell-modules/make-package-set.nix
    # Returns a derivation whose environment contains a GHC with only
    # the dependencies of packages listed in `packages`, not the
    # packages themselves. Using nix-shell on this derivation will
    # give you an environment suitable for developing the listed
    # packages with an incremental tool like cabal-install.
      requiredHaskellPackages = drvs: let
        # modules = lib.filter (x: x.isHaskellLibrary or false) drvs;
      # # TODO foireux
      # in lib.unique (lib.concatLists (lib.catAttrs "requiredPythonModules" modules));
  # haskellPackages = pkgs.callPackage makePackageSet {
  #   package-set = initialPackages;
  #   inherit stdenv haskellLib ghc buildHaskellPackages extensible-self all-cabal-hashes;
  # };

        selected = drvs haskellPackages;

        packageInputs = map getBuildInputs selected;
      in
        # might be possible to further refine
        packageInputs;


      extraHaskellPackages = hs: with hs; [
        # hie
        all-hies.versions.ghc864
        gutenhasktags
        haskdogs # seems to build on hasktags/ recursively import things
        hasktags
      ] 
      # ++ requiredHaskellPackages drvs
      ;


      # Here we generate a neovim config that allows to work with the passed 'drvs'
      # for instance adding the python propagatedBuildInputs if needed
      # or haskell ones if it's a haskell project etc.
      generatedConfig = {
        extraPython3Packages = compatFun (requiredPythonModules);
        # haskellPackages
        # TODO do the same for ruby / haskell
      } 
      # // lib.optionalAttrs (requiredHaskellPackages != [])  {

      #   withHaskell = true;
      #   inherit extraHaskellPackages;
      # }
      ;

      finalConfig = super.neovimConfig (
        super.lib.mkMerge [
          # project specific user config
          userConfig
          # my miniimal global config, when I am out of a nix-shell
          # the plugins/environments I always want available
          self.neovimDefaultConfig
          # a config generated from the input 'drvs' with an appropriate development
          # environment.
          generatedConfig
        ]
      );
    in
      wrapNeovim neovim-unwrapped-master (finalConfig);


  neovim-unwrapped-master = (super.neovim-unwrapped).overrideAttrs (oldAttrs: {
	  name = "neovim";
	  version = "nightly";

      src = builtins.fetchGit {
        # url = git@github.com:neovim/neovim.git;
        # url = https://github.com/neovim/neovim.git;
        url = https://github.com/teto/neovim.git;
        # ref = "master";
        # rev = "";
        # rev = "d81b510ecf1890828caa653ebb2fa053131f3265";
        # checksum = "1prmibvr5v1cri71miy08qd1pvbnxmy04irnrxan2ynv95w0q0qm";
      };

  });

  # the one to use with coc.nvim
  # https://github.com/neoclide/coc.nvim/wiki/F.A.Q#how-to-make-preview-window-shown-aside-with-pum
  # neovim-unwrapped-float = (super.neovim-unwrapped).overrideAttrs (oldAttrs: {
	  # name = "neovim";
	  # version = "float";

  #     # src = builtins.fetchGit {
  #     #   url = https://github.com/chemzqm/neovim.git;
  #     #   rev = "293ce565ada9d8bc6f1d6e4f61b787cfd554ecd9";
  #     #   # ref = "+refs/pull/6619/head";
  #     # };
  # });


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

    # withHaskell = true;
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
        # withHaskell = false;
        withRuby = false; # for vim-rfc/GhDashboard etc.

        # TODO use them only if 
        customRC = ''
          " always see at least 10 lines
          set scrolloff=10
          set hidden

        " Failed to start language server: No such file or directory: 'pyls'
        " todo do the same for pyls/vimtex etc
        " let g:vimtex_compiler_latexmk = {}
        " latexmk is not in combined.small/basic
        " vimtex won't let us setup paths to bibtex etc, we can do it in .latexmk ?

        " fnamemodify( g:python3_host_prog, ':p:h')
        let g:LanguageClient_serverCommands = {
             \ 'python': [ g:python3_host_prog, '-mpyls', '-vv', '--log-file' , '/tmp/lsp_python.log']
             \ , 'haskell': ['hie-wrapper', '--lsp', '-d', '--vomit', '--logfile', '/tmp/lsp_haskell.log' ]
             \ , 'cpp': ['${super.pkgs.cquery}/bin/cquery', '--log-file=/tmp/cq.log']
             \ , 'c': ['${super.pkgs.cquery}/bin/cquery', '--log-file=/tmp/cq.log']
             \ , 'nix': ['nix-lsp']
             \ }

        let g:neomake_python_mypy_exe = fnamemodify( g:python3_host_prog, ':p:h').'/mypy'

        autocmd BufReadPost *.pdf silent %!${self.pkgs.xpdf}/bin/pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78
        ''
        ;

    # TODO provide an upper level
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
      # pyls-mypy # can't find imports :s
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

