final: prev:
let
  startPlugins = with prev.pkgs.vimPlugins; [
      # echodoc-vim

      # to install manually with coc.nvim:
      # - coc-vimtex  coc-snippets 
      # use coc-yank for yank history
      editorconfig-vim
      # coc-git  # doesn't like it when it's user installed
      # coc-nvim
      # coc-python # test
      # coc-translator  # not available yet
      # csv-vim
      # replaced by coc
      vim-fugitive
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
      # vim-CtrlXA
      vim-dasht
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
      # TODO this one will be ok once we patch it
      # vim-markdown-composer  # WIP

      # vim-livedown
      # markdown-preview-nvim # :MarkdownPreview
      nvim-markdown-preview  # :MarkdownPreview

      # vim-markdown-preview  # WIP
      # vim-highlightedyank
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
      # deoplete-khard
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
      requiredPythonModules =  (final.python3Packages.requiredPythonModules drvs );

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
        selected = drvs final.haskellPackages;

        packageInputs = map final.getBuildInputs selected;
      in
        # might be possible to further refine
        packageInputs;


      extraHaskellPackages = hs: with hs; [
        # hie
        # all-hies.versions.ghc865
        # gutenhasktags
        # haskdogs # seems to build on hasktags/ recursively import things
        # hasktags
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

      finalConfig = final.neovimConfig (
        final.lib.mkMerge [
          # project specific user config
          userConfig
          # my miniimal global config, when I am out of a nix-shell
          # the plugins/environments I always want available
          neovimDefaultConfig
          # a config generated from the input 'drvs' with an appropriate development
          # environment.
          generatedConfig
        ]
      );
    in
    final.wrapNeovim neovim-unwrapped-master {
      # extraMakeWrapperArgs
      # rename configure ?
      # TODO should be able to add some packages in PATH like jq
      structuredConfigure = finalConfig;
    };

    # look at the makefile
    # libtermkey = prev.enableDebugging (
    # # libtermkey =
    #   final.libtermkey.overrideAttrs( oa: {
    #   name = "libtermkey-matt-${oa.version}";
    #   # oa.makeFlags
    #   makeFlags =  [ "PREFIX=/home/teto/libtermkey/build" "DEBUG=1"];
    # }));

    # libvterm-neovim-master = final.libvterm-neovim.overrideAttrs(oa: {
    #   src = final.fetchFromGitHub {
    #     owner = "neovim";
    #     repo = "libvterm";
    #     rev = "4a5fa43e0dbc0db4fe67d40d788d60852864df9e";
    #     sha256 = "0hkzqng3zs8hz327wdlhzshcg0qr31fhsbi9mvifkyly6c3y78cx";
    #   };
    # });


    # libvterm-neovim = libvterm-neovim-master;
  neovim-unwrapped-master = final.neovim-unwrapped.overrideAttrs (oldAttrs: {
	  name = "neovim";
	  version = "official-master";
      src = builtins.fetchGit {
        url = https://github.com/neovim/neovim.git;
        ref = "master";
        # url = https://github.com/neovim/neovim.git;
        # ref = "diagnostic";
      };
      # src = final.fetchFromGitHub {
      #   owner = "teto";
      #   repo = "neovim";
      #   rev = "b81427c114fc36c96bb30655cb572eed6b503832";
      #   sha256 = "XeEzsh2qtdd/uthsStkZsmCydDm+kcCplpSB+gNwArI=";
      # };

  });

  neovim-unwrapped-treesitter = (final.neovim-unwrapped).overrideAttrs (oldAttrs: {
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
  # TODO add withHaskell + the limited code
  # add a package to haskell function
  neovimDefaultConfig = {
        withPython3 = true;
        withPython = false;
        # withHaskell = false;
        withRuby = false; # for vim-rfc/GhDashboard etc.
        withNodeJs = true; # used by coc.vim

        # for pdf2text
        # addToPath = [ poppler_utils ];

        # TODO use them only if
        customRC = ''
          " always see at least 10 lines
          set scrolloff=10
          set hidden
        autocmd BufReadPost *.pdf silent %!${prev.pkgs.xpdf}/bin/pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78
        ''
        # autocmd BufReadPost *.pdf silent %!${prev.pkgs.poppler_utils}/bin/pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78
        # if we support coc.nvim
        # + ''
        #   let g:coc_node_path = '${prev.pkgs.nodejs}/bin/node'
        # ''

        # LanguageClient support
        # + ''
        # " fnamemodify( g:python3_host_prog, ':p:h')
        # let g:LanguageClient_serverCommands = {
        #      \ 'python': [ g:python3_host_prog, '-mpyls', '-vv', '--log-file' , '/tmp/lsp_python.log']
        #      \ , 'haskell': ['hie-wrapper', '--lsp', '-d', '--vomit', '--logfile', '/tmp/lsp_haskell.log' ]
        #      \ , 'cpp': ['${final.pkgs.cquery}/bin/cquery', '--log-file=/tmp/cq.log']
        #      \ , 'c': ['${final.pkgs.cquery}/bin/cquery', '--log-file=/tmp/cq.log']
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
      # pandas # broken
      jedi
      urllib3
      # pygments # for pygmentize and minted in latex
      mypy
      # generates https://github.com/tomv564/pyls-mypy/issues/22
      pyls-mypy # can't find imports :s
      python-language-server
      pycodestyle
    ]
    ;

  };

  neovim-dev = (final.pkgs.neovim-unwrapped.override  {
    # name = "neovim-test";
    doCheck=true;
    # withDoc=true;
    devMode=true;
    stdenv = final.pkgs.llvmPackages_latest.stdenv;
  }).overrideAttrs(oa:{
    cmakeBuildType="debug";

    version = "master";
    src = builtins.fetchGit {
      url = https://github.com/neovim/neovim.git;
      # url = https://github.com/teto/neovim.git;
      # ref = "inlinefolds_matt";
    };

    buildInputs = oa.buildInputs ++ ([ final.pkgs.tree-sitter ]);
  });
}
