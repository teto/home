{
  config,
  pkgs,
  lib,
  # flakeSelf,
  ...
}:
let
  inherit (lib)
    luaPlugin
    ;

  pluginsMap = {
    telescopePlugins = [
      # { plugin = telescope-nvim; }
      # pkgs.vimPlugins.telescope-fzf-native-nvim # for use with smart-open + fzf algo
      # telescope-fzf-native-nvim # needed by smart-open.nvim
    ];

    filetypePlugins = [
      # TODO package neomutt.vim
      # { plugin = wmgraphviz-vim; }
      # { plugin = vim-toml; }
    ];

    colorschemePlugins = with pkgs.vimPlugins; [
      { plugin = sonokai; }
      { plugin = tokyonight-nvim; }
      { plugin = molokai; }
      { plugin = onedark-nvim; }
      { plugin = dracula-vim; }
      # monkai-pro
      { plugin = vim-monokai; }
      { plugin = vim-janah; }
      { plugin = tokyonight-nvim; }
      (luaPlugin {
        # required by some colorscheme
        plugin = colorbuddy-nvim;
      })
    ];

    luaPlugins = with pkgs.vimPlugins; [

      # { plugin = modicator-nvim; }
      # testing my fork
      # { plugin = diffview-nvim; }

      (luaPlugin {
        plugin = marks-nvim;
        config = # lua
          ''
            require'marks'.setup {
                -- whether to map keybinds or not. default true
                default_mappings = true,
                -- whether movements cycle back to the beginning/end of buffer. default true
                cyclic = true,
                -- whether the shada file is updated after modifying uppercase marks. default false
                force_write_shada = false,
                -- how often (in ms) to redraw signs/recompute mark positions.
                -- higher values will have better performance but may cause visual lag,
                -- while lower values may cause performance penalties. default 150.
                refresh_interval = 1000,
                -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
                -- marks, and bookmarks.
                -- can be either a table with all/none of the keys, or a single number, in which case
                -- the priority applies to all marks.
                -- default 10.
                sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
                -- marks.nvim allows you to up to 10 bookmark groups, each with its own
                -- sign/virttext. Bookmarks can be used to group together positions and quickly move
                -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
                -- default virt_text is "".
                bookmark_0 = {
                  sign = "⚑",
                  virt_text = "hello world"
                },
                mappings = {}
            }
          '';
      })

      # install via rocks
      # vim-lion # Use with gl/L<text object><character to align to

      # (luaPlugin {
      #   # prettier quickfix
      #   plugin = nvim-bqf;
      #   config = ''
      #     require'bqf'.setup({
      #      preview = {
      #       delay_syntax = 0
      #      }
      #     })
      #   '';
      # })

      # move to Rocks
      # (luaPlugin { plugin = fugitive-gitlab-vim; })
    ];
  };

  # mcp-hub = flakeSelf.inputs.mcp-hub.packages.${pkgs.stdenv.hostPlatform.system}.mcp-hub;

  # luaPlugin =
  #   attrs:
  #   attrs
  #   // {
  #     type = "lua";
  #     config = lib.optionalString (attrs ? config && attrs.config != null) (
  #       genBlockLua attrs.plugin.pname attrs.config
  #     );
  #   };

  blinkPlugins = [
    pkgs.vimPlugins.blink-cmp # nixpkgs' one
    # pkgs.vimPlugins.blink-cmp-git # autocomplete github issues/PRs
  ];

  neotestPlugins = [
    # neotest
    # neotest-haskell
  ];

  treesitterPlugins = [
    # pkgs.vimPlugins.nvim-treesitter-pairs
    # pkgs.vimPlugins.nvim-treesitter-textobjects
    pkgs.vimPlugins.nvim-treesitter-parsers.nix
    pkgs.vimPlugins.nvim-treesitter-parsers.hurl
    pkgs.vimPlugins.nvim-treesitter-parsers.python
    # pkgs.vimPlugins.nvim-treesitter-parsers.norg
  ];

  filetypePlugins = with pkgs.vimPlugins; [
    { plugin = neomutt-vim; }
    { plugin = pkgs.vimPlugins.hurl; }
    { plugin = wmgraphviz-vim; }
    # { plugin = fennel-vim; }
    { plugin = vim-toml; } # TODO use treesitter
    # { plugin = dhall-vim; }
    # { plugin = kmonad-vim; }
    { plugin = vim-just; }
    # moonscript-vim
    # idris-vim
  ];

  luaPlugins = with pkgs.vimPlugins; [

    # (luaPlugin {
    #   plugin = avante-nvim;
    #   #   .overrideAttrs({
    #   #
    #   #   src = flakeSelf.inputs.avante-nvim-src;
    #   # });
    #   # require("avante").setup()
    #   # config = ''
    #   # require("avante_lib").load()
    #   # '';
    #
    # })
    { plugin = nui-nvim; }
    { plugin = nvim-colorizer-lua; }
    pkgs.vimPlugins.typescript-tools-nvim

    # pkgs.vimPlugins.gitlab-vim  # not

    # not upstreamed yet
    # (luaPlugin { plugin = nvim-lua-gf; })
    # (luaPlugin { plugin = luasnip; })
    # required by trouble
    # (luaPlugin { plugin = nvim-web-devicons; })
    # TODO it needs some extra care

    # TODO should be able to handle it via rocks ?
    # avante lets you use neovim as cursor IDE
    # (luaPlugin { plugin = avante-nvim; })

    # (luaPlugin { plugin = haskell-tools-nvim; })

    # I've not been using it so far
    # (luaPlugin { plugin = nvim-dap; })

    # disabling as long as it depends on nvim-treesitter
    # can now be installed via Rocks
    # (luaPlugin {
    #   # matches nvim-orgmode
    #   plugin = orgmode;
    #   # TODO autoload via lz.n instead
    #   # config = '' '';
    # })

    (luaPlugin {
      # for yaml lsp
      plugin = SchemaStore-nvim;
    })

    # this could be moved to my config
    (luaPlugin {
      plugin = nvimdev-nvim;
      optional = true;
      config = # lua
        ''
          -- nvimdev {{{
          -- call nvimdev#init(--path/to/neovim--)
          vim.g.nvimdev_auto_init = 1
          vim.g.nvimdev_auto_cd = 1
          -- vim.g.nvimdev_auto_ctags=1
          vim.g.nvimdev_auto_lint = 1
          vim.g.nvimdev_build_readonly = 1
          --}}}
        '';
    })
    (luaPlugin { plugin = sniprun; })
  ];

  extraPackages = with pkgs; [
    bash-language-server
    # black
    editorconfig-checker # used in null-ls
    fswatch # better file watching starting with 0.10
    # go # for gitlab.nvim, we can probably ditch it afterwards
    luajitPackages.luacheck

    luau-lsp

    # luaformatter # broken
    # nvimLua.pkgs.luarocks # should be brought by rocks config

    # luaPackages.lua-lsp
    # lua53Packages.teal-language-server
    # codeium # ideally not needed and referenced by codeium-vim directly
    haskellPackages.hasktags
    haskellPackages.fast-tags

    manix # should be no need, telescope-manix should take care of it
    nodePackages.vscode-langservers-extracted # needed for jsonls aka "vscode-json-language-server"
    # prettier sadly can't use buildNpmPackage because no lockfile https://github.com/NixOS/nixpkgs/issues/229475
    # dockerfile-language-server

    # TODO map it to a plugin instead
    # nodePackages.typescript-language-server

    # pandoc is used by a bunch of plugins, including feed.nvim
    # while I wish feed.nvim would be packaged with it
    # for markdown preview, should be in the package closure instead
    pandoc
    # pythonPackages.pdftotext  # should appear only in RC ? broken
    nil # a nix lsp, can be debugged with NIL_LOG_PATH and NIL_LOG=nil=debug
    nixd # another nix LSP

    just-lsp
    # rnix-lsp
    rust-analyzer
    shellcheck
    # lua-language-server # replaced with emmylua-ls
    gopls # LSP for go
    marksman # markdown LSP server

    # for none-ls
    # nodePackages.prettier # for none-ls json formatting ?
    # nodePackages.prettier
    python3Packages.flake8 # for nvim-lint and some nixpkgs linters
    # soxWithMp3 = final.sox.override { llama-cpp = llama-cpp-matt; };

    pyright # python lsp

    tree-sitter # might help install treesitter grammars
    yaml-language-server # ~100MB
    yamllint # for none-ls json formatting
    yamlfmt
  ];

  # TODO get lua interpreter to select the good lua packages
  # nvimLua = config.programs.neovim.finalPackage.passthru.unwrapped.lua;

  # finalLua = nvimLua.override {
  #   packageOverrides = flakeSelf.inputs.rikai-nvim.overlays.luaOverlay;
  # };

  vimPlugins = pkgs.vimPlugins;
in
{
  enableBlink = true;
  enableMyDefaults = true;
  useAsManViewer = true;

  lsp.mapOnAttach = true;
  lualsAddons = true;

  treesitter = {
    enable = true;

    plugins = [
      vimPlugins.nvim-surround
    ];
  };

  # TODO generate code that prepends to PATH from extraPackages
  extraLuaConfig =

    # -- look at :h statusline to see the available 'items'
    # -- let &titlestring=" %t %{len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) } - NVIM"
    # in
    # lua
    lib.mkMerge [
      # -- testing order 700
      # (lib.mkOrder 0 ''vim.env.PATH = "${lib.makeBinPath config.programs.neovim.extraInitLuaPackages}:"..vim.env.PATH'')
      # (lib.mkOrder 700 "-- testing order 700 ")
      (lib.mkAfter "require('init-manual') ")
    ];

  plugins = [
    # Install with rocks else there is a problem
    # { plugin = vimPlugins.image-nvim; }

    # TODO replaced with https://github.com/yutkat/git-rebase-auto-diff.nvim
    # {
    #   # display git diff while rebasing, pretty dope
    #   # my complaints: has issues with sync mode
    #   plugin = pkgs.vimPlugins.auto-git-diff;
    #   # config = ''
    #   # let g:auto_git_diff_disable_auto_update=1
    #   # '';
    # }

    # TODO move to default ones
    (luaPlugin {
      plugin = pkgs.vimPlugins.unicode-vim;
      # -- since the autoadd was disabled/doesn't seem to work
      # ${pkgs.vimPlugins.unicode-vim.passthru.initLua}
      config = ''
        -- overrides ga
        vim.keymap.set ( "n", "ga",  "<Plug>(UnicodeGA)", { remap = true, } )
      '';
    })

    # TODO move to rocks
    # {
    #   plugin = vim-dasht;
    # config = ''
    # " When in Python, also search NumPy, SciPy, and Pandas:
    # let g:dasht_filetype_docsets = {} " filetype => list of docset name regexp
    # let g:dasht_filetype_docsets['python'] = ['(num|sci)py', 'pandas']
    # " search related docsets
    # nnoremap <Leader>k :Dasht<Space>
    # " search ALL the docsets
    # nnoremap <Leader><Leader>k :Dasht!<Space>
    # " search related docsets
    # nnoremap ,k <Cmd>call Dasht([expand('<cword>'), expand('<cWORD>')])<Return>
    # " search ALL the docsets
    # nnoremap <silent> <Leader><Leader>K :call Dasht([expand('<cword>'), expand('<cWORD>')], '!')<Return>
    # '';
    #   # optional = true;
    # }

    # {
    #   plugin = sql-nvim;
    #   # config = "let g:sql_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'";
    # }

  ]
  ++ luaPlugins
  ++ blinkPlugins
  ++ filetypePlugins
  ++ treesitterPlugins
  ++ pluginsMap.colorschemePlugins
  ++ pluginsMap.luaPlugins
  # ++ telescopePlugins
  ++ neotestPlugins;

  # plugins = with pkgs.vimPlugins; [
  #  tint-nvim
  # ];

  # viml config, to test home-manager setup
  # extraConfig = ''
  #  '';

  withNodeJs = false; # for tests
  withRuby = false; # for tests

  enableRocks = true;
  highlightOnYank = true;
  enableFzfLua = true;

  # Some of these packages are only available in my lua overlay. Since those are used
  # 
  extraLuaPackages = lp: [

    # for neorg until  we fix
    lp.lua-utils-nvim
    lp.pathlib-nvim
    # nvim-treesitter-legacy-api == 0.9.2

    # importing dependencies of rikai.nvim
    # TODO: do it from overlay or look at the plugin itself
    # lp.sqlite
    lp.lsqlite3
    # lp.lual
    lp.utf8
    lp.alogger
    lp.mega-cmdparse
    lp.mega-logging # should not be needed ?

    lp.nvim-nio # for rocks.nvim
    # lp.fzy

  ]
  # nvimLua.pkgs.rest-nvim.propagatedBuildInputs
  ;

  extraPython3Packages = p: [
    p.jupyter-client
    p.pyperclip # if you want to use molten_copy_output
    p.nbformat # to import/export notebooks
    p.pynvim
  ];

  # attempt
  extraInitLuaPackages = config.programs.neovim.extraPackages;

  # just to test viml nixpkgs example
  # extraConfig = ''
  #   let g:grug_far = { 'startInInsertMode': v:false }
  # '';

  extraPackages =
    extraPackages
    # flakeSelf.inputs.rest-nvim.packages.${pkgs.stdenv.hostPlatform.system}.rest-nvim-dev
    # TODO remove once it's automatic
    # ++ pkgs.vimPlugins.llm-nvim.runtimeDeps # temporary workaround
    # provides typescript-language-server
    ++ pkgs.vimPlugins.typescript-tools-nvim.runtimeDeps
    ++ [
      pkgs.typescript # for tsserver
      pkgs.stylua # for lua formatting
      # pkgs.gitlab-ci-ls # gitlab lsp

      # mcp-hub
    ];
}
