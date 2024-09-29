{
  config,
  pkgs,
  lib,
  flakeInputs,
  ...
}:
let
  genBlockLua = title: content: ''
    -- ${title} {{{
    ${content}
    -- }}}
  '';

  luaPlugin =
    attrs:
    attrs
    // {
      type = "lua";
      config = lib.optionalString (attrs ? config && attrs.config != null) (
        genBlockLua attrs.plugin.pname attrs.config
      );
    };

  telescopePlugins = with pkgs.vimPlugins; [

    # lua require'telescope-all-recent'.toggle_debug()

    # (luaPlugin {
    #   plugin = telescope-all-recent-nvim; 
    #   config = ''
    #        require'telescope-all-recent'.setup{
    #    -- your config goes here
    #  }'';
    # })

  ];

  # orgmodePlugins = with pkgs.vimPlugins; [ 
  neorgPlugins = with pkgs.vimPlugins; [
    # (luaPlugin { plugin = neorg-telescope; })
  ];

  # try via rocks.nvim first
  neotestPlugins = with pkgs.vimPlugins; [
    # neotest 
    # neotest-haskell
  ];

  luaPlugins = with pkgs.vimPlugins; [
    pkgs.vimPlugins.nvim-treesitter-parsers.nix
    pkgs.vimPlugins.nvim-treesitter-parsers.hurl
    # {
    #   # we should have a file of the grammars as plugins
    #   # symlinkJoin
    #   plugin = pkgs.symlinkJoin {
    #    name = "tree-sitter-grammars";
    #    paths = with pkgs.neovimUtils; [
          # pkgs.vimPlugins.nvim-treesitter-parsers.tree-sitter-nix
    #       # # tree-sitter-haskell # crashes with a loop
    #       # tree-sitter-html  # for rest.nvim
    #       # (grammarToPlugin pkgs.tree-sitter-grammars.tree-sitter-html) # for devdocs
    #       # pkgs.vimPlugins.nvim-treesitter.grammarPlugins.org
    #       # pkgs.vimPlugins.nvim-treesitter.grammarPlugins.norg
    #       # # (grammarToPlugin pkgs.tree-sitter-grammars.tree-sitter-norg-meta)
    #       # pkgs.vimPlugins.nvim-treesitter.grammarPlugins.nix
    #       # pkgs.vimPlugins.nvim-treesitter.grammarPlugins.http
    #       # (grammarToPlugin tree-sitter-just)
    #     ];
    #   };
    # }

    # should bring in scope fzy
    # (luaPlugin { plugin = rocks-nvim; })

    # (luaPlugin { plugin = nvim-ufo; })

    (luaPlugin { plugin = nvim-dbee; })

    # breaks setup
    # (luaPlugin { plugin =  hmts-nvim; })

    # testin
    # TODO restore
    # (luaPlugin { plugin = image-nvim; })

    # (luaPlugin { 
    #  # this is a peculiarly complex one that needs pynvim, image.nvim
    #  plugin = molten-nvim; 
    # })



    # TODO it needs some extra care

    # TODO should be able to handle it via rocks ?
    (luaPlugin { plugin = avante-nvim; })

    # (luaPlugin { plugin = haskell-tools-nvim; })

    # I've not been using it so far
    # (luaPlugin { plugin = nvim-dap; })

    # (luaPlugin {
    #   # TODO move config hee
    #   plugin = bufferline-nvim;
    # })

    # (luaPlugin { plugin = nvim-peekup; })
    # (luaPlugin {
    #   plugin = pywal-nvim;
    #   config = ''
    #   '';
    # })

    # TODO look at peek.nvim too
    # (luaPlugin {
    #   # euclio/vim-markdown-composer
    #   # https://github.com/euclio/vim-markdown-composer/issues/69#issuecomment-1103440076
    #   # see https://github.com/euclio/vim-markdown-composer/commit/910fd4321b7f25fbab5fdf84e68222cbc226d8b1
    #   # https://github.com/euclio/vim-markdown-composer/issues/69#event-6528328732
    #   # ComposerUpdate / ComposerStart
    #   # we can now set g:markdown_composer_binary
    #   # " is that the correct plugin ?
    #   # " let $NVIM_MKDP_LOG_LEVEL = 'debug'
    #   # " let $VIM_MKDP_RPC_LOG_FILE = expand('~/mkdp-rpc-log.log')
    #   # " let g:mkdp_browser = 'firefox'
    #   plugin = vim-markdown-composer;
    #   config = ''
    #     -- use with :ComposerStart
    #     vim.g.markdown_composer_autostart = 0
    #     vim.g.markdown_composer_binary = '${vim-markdown-composer.vimMarkdownComposerBin}/bin/markdown-composer'
    #   '';
    # })

    # disabled because of https://github.com/rktjmp/lush.nvim/issues/89
    # (luaPlugin { plugin = lush-nvim; }) # dependency of some colorschemes

    (luaPlugin {
      # TODO could try 
      # really helps with syntax highlighting
      plugin = haskell-vim;
      config = ''
        vim.g.haskell_enable_quantification = 1   -- to enable highlighting of `forall`
        vim.g.haskell_enable_recursivedo = 1      -- to enable highlighting of `mdo` and `rec`
        vim.g.haskell_enable_arrowsyntax = 1      -- to enable highlighting of `proc`
        vim.g.haskell_enable_pattern_synonyms = 1 -- to enable highlighting of `pattern`
        vim.g.haskell_enable_typeroles = 1        -- to enable highlighting of type roles
        vim.g.haskell_enable_static_pointers = 1  -- to enable highlighting of `static`
        vim.g.haskell_backpack = 1                -- to enable highlighting of backpack keywords
        vim.g.haskell_indent_disable=1
        '';
    })


    # disabling as long as it depends on nvim-treesitter
    # (luaPlugin {
    #   # matches nvim-orgmode
    #   plugin = orgmode;
    #   # config = ''
    #   #   require('orgmode').setup{
    #   #       org_capture_templates = {'~/nextcloud/org/*', '~/orgmode/**/*'},
    #   #       org_default_notes_file = '~/orgmode/refile.org',
    #   #       -- TODO add templates
    #   #       org_agenda_templates = { t = { description = 'Task', template = '* TODO %?\n  %u' } },
    #   #   }'';
    # })

    (luaPlugin {
      plugin = SchemaStore-nvim;
    })

    {
      # node-based :MarkdownPreview
      plugin = markdown-preview-nvim;
      # let g:vim_markdown_preview_github=1
      # let g:vim_markdown_preview_use_xdg_open=1
    }

    # { plugin = kui-nvim; }
    # FIX https://github.com/NixOS/nixpkgs/issues/169293 first

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
        --}}}'';
    })

    # (luaPlugin { plugin = sniprun; })
    (luaPlugin { plugin = telescope-nvim; })
    # (luaPlugin { plugin = telescope-manix; })
    # call with :Hoogle
    # (luaPlugin { plugin = glow-nvim; })

    # (luaPlugin {
    #   plugin = fzf-hoogle-vim;
    #   config = ''
    #    vim.g.hoogle_path = "hoogle"
    #    vim.g.hoogle_fzf_cache_file = vim.fn.stdpath('cache')..'/hoogle_cache.json'
    #    '';
    # })

    (luaPlugin { plugin = stylish-nvim; })

    # doesnt seem to work + problematic on neovide
    # (luaPlugin { 
    #  plugin = image-nvim;
    #     /* lua */
    #     config =  ''
    #       require("image").setup({
    #         backend = "kitty",
    #         integrations = {
    #           markdown = {
    #             enabled = true,
    #             sizing_strategy = "auto",
    #             download_remote_images = false,
    #             clear_in_insert_mode = true,
    #           },
    #           neorg = {
    #             enabled = false,
    #           },
    #         },
    #         max_width = nil,
    #         max_height = nil,
    #         max_width_window_percentage = nil,
    #         max_height_window_percentage = 50,
    #         kitty_method = "normal",
    #         kitty_tmux_write_delay = 10,
    #         window_overlap_clear_enabled = false,
    #         window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    #       })
    #     '';
    # })

    # WIP
    # (luaPlugin { plugin = nvim-telescope-zeal-cli; })

    (luaPlugin { plugin = minimap-vim; })

    # TODO put into rocks.nvim
    # (luaPlugin { plugin = rest-nvim; })
  ];

  filetypePlugins = with pkgs.vimPlugins; [
    # { plugin = pkgs.vimPlugins.hurl; }
    { plugin = wmgraphviz-vim; }
    { plugin = fennel-vim; }
    { plugin = vim-toml; } # TODO use treesitter
    { plugin = dhall-vim; }
    { plugin = kmonad-vim; }
    { plugin = vim-just; }
    # moonscript-vim
    # idris-vim
  ];

  extraPackages = with pkgs; [
    bash-language-server
    black
    editorconfig-checker # used in null-ls
    fswatch # better file watching starting with 0.10
    go # for gitlab.nvim, we can probably ditch it afterwards
    # gcc # this is sadly a workaround to be able to run :TSInstall
    luajitPackages.luacheck

    luaformatter
    nvimLua.pkgs.luarocks

    # luaPackages.lua-lsp
    # lua53Packages.teal-language-server
    # codeium # ideally not needed and referenced by codeium-vim directly
    haskellPackages.hasktags
    haskellPackages.fast-tags

    # llm-ls
    manix # should be no need, telescope-manix should take care of it
    # nodePackages.vscode-langservers-extracted # needed for typescript language server IIRC
    # prettier sadly can't use buildNpmPackage because no lockfile https://github.com/NixOS/nixpkgs/issues/229475
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.typescript-language-server
    # pandoc # for markdown preview, should be in the package closure instead
    # pythonPackages.pdftotext  # should appear only in RC ? broken
    nil # a nix lsp
    # rnix-lsp
    rust-analyzer
    shellcheck
    sumneko-lua-language-server

    gopls # LSP for go

    # for none-ls
    nixfmt # -rfc-style #
    nodePackages.prettier
    python3Packages.flake8 # for nvim-lint and some nixpkgs linters
    # soxWithMp3 = final.sox.override { llama-cpp = llama-cpp-matt; };

    # to enable GpWhisper in gp.nvim
    (sox.override ({ enableLame = true; }))

    pyright

    yaml-language-server # ~100MB
    yamllint
    yamlfmt
  ];

  # TODO get lua interpreter to select the good lua packages
  nvimLua = config.programs.neovim.finalPackage.passthru.unwrapped.lua;
in
{
  programs.neovim = {

    plugins = luaPlugins ++ filetypePlugins ++ telescopePlugins ++ neorgPlugins ++ neotestPlugins;

    # plugins = with pkgs.vimPlugins; [
    #  tint-nvim
    # ];
    # -- vim.lsp.set_log_level("info")
    # -- require my own manual config
    # -- logs are written to /home/teto/.cache/vim-lsp.log

    # viml config, to test home-manager setup
    # extraConfig = ''
    #  '';

    extraLuaConfig = # lua
      ''
        require('init-manual')
      '';

    # HACK till we fix it
    # or else we need a vim.g.sqlite_clib_path
    extraLuaPackages = lp: [
      lp.sqlite 
    ]
    # nvimLua.pkgs.rest-nvim.propagatedBuildInputs
    ;

    extraPython3Packages = p: [
      p.jupyter_client
      p.pyperclip # if you want to use molten_copy_output
      p.nbformat # to import/export notebooks
      p.pynvim
    ];
    extraPackages = extraPackages;
  };

  home.packages = extraPackages;
}
