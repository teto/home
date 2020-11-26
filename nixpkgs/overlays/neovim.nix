final: prev:
let
  startPlugins = with prev.pkgs.vimPlugins; [
      # # vim-livedown
      # # markdown-preview-nvim # :MarkdownPreview
      # # nvim-markdown-preview  # :MarkdownPreview
      # # reuse vimtex once https://github.com/neovim/neovim/issues/9390 is fixed
    ];
in
rec {
  neovim-unwrapped-master = let
    in
    (prev.neovim-unwrapped.override({
      lua = final.enableDebugging final.luajit;
    })).overrideAttrs (oa: {
      name = "unwrapped-neovim-master";
      version = "official-master";
      cmakeBuildType="Debug";
      src = builtins.fetchGit {
          # url = https://github.com/neovim/neovim.git;
        url = https://github.com/teto/neovim.git;
        ref = "lsp_progress";
        rev = "b739486ea691066a1dc41e323d7b2f25577ee3e4";
      };
      # src = builtins.fetchGit {
      #   # url = https://github.com/BK1603/neovim.git;
      #   # ref = "fswatch-autoread";
      #   url = https://github.com/neovim/neovim.git;
      #   # rev = "e5d98d85693245fec811307e5a2ccfdea3a350cd"; # 30 septembre
      #   rev = "8821587748058ee1ad8523865b30a03582f8d7be"; # 1er novembre
      #   ref = "master";
      # };
      buildInputs = oa.buildInputs ++ ([
        final.tree-sitter
      ]);


      # src = final.fetchFromGitHub {
      #   owner = "neovim";
      #   repo = "neovim";
      #   rev = "9f704c88a57cfb797c21c19672ea6617e9673360";
      #   sha256 = "sha256-NNUyWczL6dEPrLVsJILnzrSGKmK1/E5TURSJDjhwSVE=";
      # };

  });

  neovim-dev = let
      pythonEnv = final.pkgs.python3;
      devMode = true;
    in (final.pkgs.neovim-unwrapped.override  {
      doCheck=true;
      # devMode=true;
      stdenv = final.pkgs.llvmPackages_latest.stdenv;
  }).overrideAttrs(oa:{
    cmakeBuildType="Debug";

    # TODO add luaCheck
    # cmakeFlags = oa.cmakeFlags ++ "-DLUACHECK_PRG=${final.}/bin/luacheck";
    version = "master";
    nativeBuildInputs = oa.nativeBuildInputs
      ++ final.pkgs.lib.optionals devMode (with final.pkgs; [
        pythonEnv
        include-what-you-use  # for scripts/check-includes.py
        jq                    # jq for scripts/vim-patch.sh -r
        doxygen
      ]);

  });

  # this generates a config appropriate to work with the passed derivations
  # for instance to develop on a software from a nix-shell
  genNeovim = drvs: userConfig:
    let

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
        # hasktags
      ]
      # ++ requiredHaskellPackages drvs
      ;

      finalConfig = final.neovimConfig (
        final.lib.mkMerge [
          # project specific user config
          userConfig
          # my miniimal global config, when I am out of a nix-shell
          # the plugins/environments I always want available
          neovimDefaultConfig
        ]
      );
    in
    final.wrapNeovimStructured neovim-unwrapped-master {
      # TODO should be able to add some packages in PATH like jq
      structuredConfigure = finalConfig;
    };


  # makeNeovimConfig = {}:
  neovimTreesitterConfig = prev.neovimUtils.makeNeovimConfig {
    withPython3 = false;
    plugins = with prev.vimPlugins; [
      {
        plugin = nvim-treesitter;
        # luaConfig = ''
        # local nvim_lsp = require 'nvim_lsp'
        # '';
      }
# " Plug 'nvim-treesitter/completion-treesitter' " extension of completion-nvim,
# " depends on nvim-treesitter/nvim-treesitter
# " Plug 'nvim-treesitter/highlight.lua' " to test treesitter
# " Plug 'nvim-treesitter/nvim-treesitter' " to test treesitter
# " Plug '~/nvim-treesitter' " to test treesitter
# " Plug 'nvim-treesitter/playground'
# " Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    ];

  };

  neovimHaskellConfig = prev.neovimUtils.makeNeovimConfig {
    withPython3 = false;
    plugins = with prev.vimPlugins; [
      {
        plugin = nvim-lspconfig;
        # luaConfig = ''
        # local nvim_lsp = require 'nvim_lsp'
        # '';
      }
    ];
  #   haskellPackages = [
  #     haskellPackages.haskdogs # seems to build on hasktags/ recursively import things
  #     haskellPackages.hasktags
  #     haskellPackages.nvim-hs
  #     haskellPackages.nvim-hs-ghcid
  #   ];
    customRC = ''
    '';

    # ajouter une config lua
    luaRC = ''
      '';
  };

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
        # todo override
            # let g:Unicode_data_directory = /home/user/data/
    # let g:Unicode_cache_directory = /tmp/

        customRC = ''
          " always see at least 10 lines
          set scrolloff=10
          set hidden
        autocmd BufReadPost *.pdf silent %!${prev.pkgs.xpdf}/bin/pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78

        let g:Unicode_data_directory='${final.vimPlugins.unicode-vim}/share/vim-plugins/unicode-vim/autoload/unicode'
        " let g:Unicode_cache_directory='${final.vimPlugins.unicode-vim}/share/vim-plugins/unicode-vim/autoload/unicode'

        ''
        # autocmd BufReadPost *.pdf silent %!${prev.pkgs.poppler_utils}/bin/pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78
        # if we support coc.nvim
        # + ''
        #   let g:coc_node_path = '${prev.pkgs.nodejs}/bin/node'
        # ''

        ;

    # TODO provide an upper level
    # configure = {
    #     packages.myVimPackage = {
    #       # see examples below how to use custom packages
    #       # loaded on launch
    #       start = startPlugins;
    #       # manually loadable by calling `:packadd $plugin-name`
    #       opt = [ ];
    #     };
    #   };

    # plugins = startPlugins;

    pluginsExperimental = {
      vim-obsession = {
        customRC = ''This is a test'';
      };
    };

    extraPython3Packages = ps: with ps; [
      jedi
      # urllib3
      # pygments # for pygmentize and minted in latex
      mypy
      # generates https://github.com/tomv564/pyls-mypy/issues/22
      # pyls-mypy # can't find imports :s
      # python-language-server
      pycodestyle
    ];
  };

  # TODO provide an upper level
  neovimConfigure = {
	packages.myVimPackage = {
	# see examples below how to use custom packages
	# loaded on launch
	start = startPlugins;
	# manually loadable by calling `:packadd $plugin-name`
	opt = [ ];
	};
  };
}
