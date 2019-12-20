self: super:
let
  startPlugins = with super.pkgs.vimPlugins; [
      # echodoc-vim

      # to install manually with coc.nvim:
      # - coc-vimtex  coc-snippets 
      # use coc-yank for yank history

      # coc-git  # doesn't like it when it's user installed
      # coc-nvim
      # coc-python # test
      # coc-translator  # not available yet
      csv-vim
      # replaced by coc
      fugitive
      far-vim

      # fails with   python module. Run `pip install neovim` to fix. For more info, :he nvim-python"
      # floobits-neovim

      fzf-vim
      # defined in overrides: TODO this should be easier: like fzf-vim should be enough
      fzfWrapper
      gruvbox

      # neomake
      nvim-terminal-lua

      # LanguageClient-neovim
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
      # ultisnips  # disabled because it maps <tab>
      unicode-vim
    ]
    # ++ [
    #   deoplete-nvim
    #   deoplete-jedi # keeps crashing
    #   deoplete-zsh # not available just yet
    #   echodoc-vim
    # ]
    ;


in
rec {
  /* for compatibility with passing extraPythonPackages as a list; added 2018-07-11 */
  compatFun = funOrList: (if builtins.isList funOrList then (_: funOrList) else funOrList);

  # this generates a config appropriate to work with the passed derivations
  # for instance to develop on a software from a nix-shell
  genNeovim = drvs: userConfig:
    let
      # isHaskellPkg
      # lib.debug.traceVal
      requiredPythonModules =  (super.python3Packages.requiredPythonModules drvs );

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

        selected = drvs super.haskellPackages;

        packageInputs = map super.getBuildInputs selected;
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

      # buildInputs = []

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
    super.wrapNeovim neovim-unwrapped-master {
      # extraMakeWrapperArgs
      # rename configure ?
      # TODO should be able to add some packages in PATH like jq
      structuredConfigure = finalConfig;
    };

    # look at the makefile
    # libtermkey = self.enableDebugging (
    # # libtermkey =
    #   super.libtermkey.overrideAttrs( oa: {
    #   name = "libtermkey-matt-${oa.version}";
    #   # oa.makeFlags
    #   makeFlags =  [ "PREFIX=/home/teto/libtermkey/build" "DEBUG=1"];
    # }));

    # libvterm-neovim-master = super.libvterm-neovim.overrideAttrs(oa: {
    #   src = super.fetchFromGitHub {
    #     owner = "neovim";
    #     repo = "libvterm";
    #     rev = "4a5fa43e0dbc0db4fe67d40d788d60852864df9e";
    #     sha256 = "0hkzqng3zs8hz327wdlhzshcg0qr31fhsbi9mvifkyly6c3y78cx";
    #   };
    # });


    # libvterm-neovim = libvterm-neovim-master;
  neovim-unwrapped-master = super.neovim-unwrapped.overrideAttrs (oldAttrs: {
	  name = "neovim";
	  version = "official-master";
      src = builtins.fetchGit {
        url = https://github.com/teto/neovim.git;
        ref = "master";
      };
      # src = super.fetchFromGitHub {
      #   owner = "neovim";
      #   repo = "neovim";
      #   rev = "b1e4ec1c2a08981683b2355715a421c0bfb64644";
      #   sha256 = "XeEzsh1qtdd/uthsStkZsmCydDm+kcCplpSB+gNwArI=";
      # };

  });

  neovim-unwrapped-treesitter = (super.neovim-unwrapped).overrideAttrs (oldAttrs: {
	  name = "neovim";
	  version = "treesitter";

      # bfredl:tree-sitter-query
      # 11113
      src = builtins.fetchGit {
        url = https://github.com/bfredl/neovim.git;
        ref = "tree-sitter-api";
      };

  });


  # neovimHaskellConfig = {
  #   withHaskell = true;
  #   haskellPackages = [
  #     haskellPackages.haskdogs # seems to build on hasktags/ recursively import things
  #     haskellPackages.hasktags
  #     haskellPackages.nvim-hs
  #     haskellPackages.nvim-hs-ghcid
  #   ];
  #   customRC = ''
  #       let g:LanguageClient_serverCommands = {
  #         'haskell': ['hie', '--lsp', '-d', '--logfile', '/tmp/lsp_haskell.log' ]
  #       }
  #     '';
  # };

  # TODO pass args to the wrapper to get access to :
  # - bash-language-server
  # - digestif ?
  neovimDefaultConfig = {
        withPython3 = true;
        withPython = false;
        # withHaskell = false;
        withRuby = false; # for vim-rfc/GhDashboard etc.
        withNodeJs = true; # used by coc.vim

        # TODO use them only if
        customRC = ''
          " always see at least 10 lines
          set scrolloff=10
          set hidden

        ''
        # autocmd BufReadPost *.pdf silent %!${self.pkgs.xpdf}/bin/pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78
        # if we support coc.nvim
        # + ''
        #   let g:coc_node_path = '${self.pkgs.nodejs}/bin/node'
        # ''

        # LanguageClient support
        # + ''
        # " fnamemodify( g:python3_host_prog, ':p:h')
        # let g:LanguageClient_serverCommands = {
        #      \ 'python': [ g:python3_host_prog, '-mpyls', '-vv', '--log-file' , '/tmp/lsp_python.log']
        #      \ , 'haskell': ['hie-wrapper', '--lsp', '-d', '--vomit', '--logfile', '/tmp/lsp_haskell.log' ]
        #      \ , 'cpp': ['${super.pkgs.cquery}/bin/cquery', '--log-file=/tmp/cq.log']
        #      \ , 'c': ['${super.pkgs.cquery}/bin/cquery', '--log-file=/tmp/cq.log']
        #      \ , 'nix': ['nix-lsp']
        #      \ }
        # ''
        # # neomake support
        # + ''
        #   let g:neomake_python_mypy_exe = fnamemodify( g:python3_host_prog, ':p:h').'/mypy'
        # ''
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

    plugins = startPlugins;

    pluginsExperimental = {
      vim-obsession = {
        customRC = ''This is a test'';
      };
    };

    extraPython3Packages = ps: with ps; [
      pandas
      jedi
      urllib3
      # pygments # for pygmentize and minted in latex
      mypy
      # generates https://github.com/tomv564/pyls-mypy/issues/22
      pyls-mypy # can't find imports :s
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
    devMode=true;
  }).overrideAttrs(oa:{
    cmakeBuildType="debug";

    version = "master";
    src = builtins.fetchGit {
      url = https://github.com/neovim/neovim.git;
    };

    nativeBuildInputs = oa.nativeBuildInputs ++ [
      self.pkgs.valgrind

      # testing between both
      self.pkgs.ccls
      self.pkgs.clang-tools  # for clangd
    ];

    buildInputs = oa.buildInputs ++ [
      self.pkgs.icu  # for treesitter unicode/ptypes.h
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
      echo "To run tests:"
      echo "VALGRIND=1 TEST_FILE=test/functional/core/job_spec.lua TEST_TAG=env make functionaltest"

    '';
  });


  # neovim-unwrapped-local = super.pkgs.neovim-unwrapped.overrideAttrs (oldAttrs: {
	  # name = "neovim-unwrapped-local";
	  # src = super.lib.cleanSource ~/neovim;
      # cmakeBuildType="debug";
      # meta.priority=0;
  # });

  }

