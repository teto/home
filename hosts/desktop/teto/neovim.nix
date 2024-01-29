{ config, pkgs, lib, flakeInputs, ... }:
let 
  genBlockLua = title: content:
    ''
    -- ${title} {{{
    ${content}
    -- }}}
    '';

  luaPlugin = attrs: attrs // {
    type = "lua";
    config = lib.optionalString (attrs ? config && attrs.config != null) (genBlockLua attrs.plugin.pname attrs.config);
  };

  telescopePlugins =  with pkgs.vimPlugins; [

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
      (luaPlugin { plugin = neorg-telescope; })
     ];


  luaPlugins = with pkgs.vimPlugins; [
    {
      # we should have a file of the grammars as plugins
      # symlinkJoin
      plugin = pkgs.symlinkJoin {
       name = "tree-sitter-grammars";
       paths = with pkgs.neovimUtils; [

          # pkgs.vimPlugins.nvim-treesitter-parsers.tree-sitter-nix
          # # tree-sitter-haskell # crashes with a loop
          # tree-sitter-html  # for rest.nvim
          (grammarToPlugin pkgs.tree-sitter-grammars.tree-sitter-html) # for devdocs
          pkgs.vimPlugins.nvim-treesitter.grammarPlugins.org
          pkgs.vimPlugins.nvim-treesitter.grammarPlugins.norg
          # (grammarToPlugin pkgs.tree-sitter-grammars.tree-sitter-norg-meta)
          pkgs.vimPlugins.nvim-treesitter.grammarPlugins.nix

          # (grammarToPlugin tree-sitter-just)
        ];
      };
    }

    # fails because of fzy
    # (luaPlugin { plugin = flakeInputs.rocks-nvim.packages.${pkgs.system}.rocks-nvim; })
    (luaPlugin { plugin = urlview-nvim; })
    (luaPlugin { plugin = nvim-ufo; })
    (luaPlugin { plugin = ollama-nvim; })
    (luaPlugin { plugin = mini-nvim; })
    # breaks setup
    # (luaPlugin { plugin =  hmts-nvim; })

    # testin
    # TODO restore
    # (luaPlugin { plugin = image-nvim; })

    (luaPlugin { 
     # this is a peculiarly complex one that needs pynvim, image.nvim
     plugin = molten-nvim; 
    })

    # (luaPlugin {
    #   plugin = vim-obsession;
    #   after = ''
    #     vim.keymap.set("n", "<Leader>$", "<Cmd>Obsession<CR>", { remap = true })
    #     vim.g.obsession_no_bufenter = true
    #   '';
    # })

    # { plugin = vim-dadbod; }
    # { plugin = vim-dadbod-completion; }
    # { plugin = vim-dadbod-ui; }

    # TODO it needs some extra care
    (luaPlugin { plugin = haskell-tools-nvim; })

    # (luaPlugin {
    #   # run with :Diffview
    #   plugin = diffview-nvim;
    #   # optional = true;
    # })

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
    (luaPlugin { plugin = lush-nvim; })
    # (luaPlugin { plugin = gruvbox-nvim; }) 
    # out of tree
    (luaPlugin {
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
    # " gutentags + gutenhasktags {{{
    # " to keep logs GutentagsToggleTrace
    # " some commands/functions are not available by default !!
    # " https://github.com/ludovicchabant/vim-gutentags/issues/152
    # let g:gutentags_define_advanced_commands=1
    # " let g:gutentags_project_root
    # " to ease with debug
    # let g:gutentags_trace=0
    # let g:gutentags_enabled = 1 " dynamic loading
    # let g:gutentags_dont_load=0 " kill once and for all
    # let g:gutentags_project_info = [ {'type': 'python', 'file': 'setup.py'},
    #                                \ {'type': 'ruby', 'file': 'Gemfile'},
    #                                \ {'type': 'haskell', 'glob': '*.cabal'} ]
    # " produce tags for haskell http://hackage.haskell.org/package/hasktags
    # " it will fail without a wrapper https://github.com/rob-b/gutenhasktags
    # " looks brittle, hie might be better
    # " or haskdogs
    # " let g:gutentags_ctags_executable_haskell = 'gutenhasktags'
    # let g:gutentags_ctags_executable_haskell = 'hasktags'
    # " let g:gutentags_ctags_extra_args
    # let g:gutentags_file_list_command = 'rg --files'
    # " gutenhasktags/ haskdogs/ hasktags/hothasktags

    # let g:gutentags_ctags_exclude = ['.vim-src', 'build', '.mypy_cache']
    # " }}}


    # disabling as long as it depends on nvim-treesitter
    # (luaPlugin {
    #   # matches nvim-orgmode
    #   plugin = orgmode;
    #   # config = ''
    #   #   require('orgmode').setup_ts_grammar()
    #   #   require('orgmode').setup{
    #   #       org_capture_templates = {'~/nextcloud/org/*', '~/orgmode/**/*'},
    #   #       org_default_notes_file = '~/orgmode/refile.org',
    #   #       -- TODO add templates
    #   #       org_agenda_templates = { t = { description = 'Task', template = '* TODO %?\n  %u' } },
    #   #   }'';
    # })

    (luaPlugin {
      plugin = SchemaStore-nvim;
      # config = ''
      #  '';
    })

    { 
    # node-based :MarkdownPreview
    plugin = markdown-preview-nvim;
    # let g:vim_markdown_preview_github=1
    # let g:vim_markdown_preview_use_xdg_open=1
    }

    # nvim-markdown-preview  # :MarkdownPreview

    { 
     # might get outdated in newer neovim
     plugin = b64-nvim; # provides B64Decode / Encode
    }
    # { plugin = kui-nvim; }
    # FIX https://github.com/NixOS/nixpkgs/issues/169293 first

    # (luaPlugin {
    # broken
    #   plugin = telescope-frecency-nvim; 
    #   config = ''
    #    require'telescope'.load_extension('frecency')
    #    '';
    # })
    (luaPlugin {
      plugin = nvimdev-nvim;
      optional = true;
      config =  /* lua */ ''
        -- nvimdev {{{
        -- call nvimdev#init(--path/to/neovim--)
        vim.g.nvimdev_auto_init = 1
        vim.g.nvimdev_auto_cd = 1
        -- vim.g.nvimdev_auto_ctags=1
        vim.g.nvimdev_auto_lint = 1
        vim.g.nvimdev_build_readonly = 1
        --}}}'';
    })
    (luaPlugin { plugin = sniprun; })
    (luaPlugin { plugin = telescope-nvim; })
    (luaPlugin { plugin = telescope-manix; })
    # call with :Hoogle
        (luaPlugin { plugin = glow-nvim; })

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
    # (luaPlugin {
    #   # reuse once https://github.com/neovim/neovim/issues/9390 is fixed
    #   plugin = vimtex;
    #   optional = true;
    #   config = ''
    #     -- Pour le rappel
    #     -- <localleader>ll pour la compilation continue du pdf
    #     -- <localleader>lv pour la preview du pdf
    #     -- see https://github.com/lervag/vimtex/issues/1058
    #     -- let g:vimtex_log_ignore 
    #     -- taken from https://castel.dev/post/lecture-notes-1/
    #     vim.g.tex_conceal='abdmg'
    #     vim.g.vimtex_log_verbose=1
    #     vim.g.vimtex_quickfix_open_on_warning = 1
    #     vim.g.vimtex_view_automatic=1
    #     vim.g.vimtex_view_enabled=1
    #     -- was only necessary with vimtex lazy loaded
    #     -- let g:vimtex_toc_config={}
    #     -- let g:vimtex_complete_img_use_tail=1
    #     -- autoindent can slow down vim quite a bit
    #     -- to check indent parameters, run :verbose set ai? cin? cink? cino? si? inde? indk?
    #     vim.g.vimtex_indent_enabled=0
    #     vim.g.vimtex_indent_bib_enabled=1
    #     vim.g.vimtex_compiler_enabled=1
    #     vim.g.vimtex_compiler_progname='nvr'
    #     vim.g.vimtex_quickfix_method="latexlog"
    #     -- 1=> opened automatically and becomes active (2=> inactive)
    #     vim.g.vimtex_quickfix_mode = 2
    #     vim.g.vimtex_indent_enabled=0
    #     vim.g.vimtex_indent_bib_enabled=1
    #     vim.g.vimtex_view_method = 'zathura'
    #     vim.g.vimtex_format_enabled = 0
    #     vim.g.vimtex_complete_recursive_bib = 0
    #     vim.g.vimtex_complete_close_braces = 0
    #     vim.g.vimtex_fold_enabled = 0
    #     vim.g.vimtex_view_use_temp_files=1 -- to prevent zathura from flickering
    #     -- let g:vimtex_syntax_minted = [ { 'lang' : 'json', \ }]

    #     -- shell-escape is mandatory for minted
    #     -- check that '-file-line-error' is properly removed with pplatex
    #     -- executable The name/path to the latexmk executable. 
    #     '';
    #   # vim.gvimtex_compiler_latexmk = {
    #   #          'backend' : 'nvim',
    #   #          'background' : 1,
    #   #          'build_dir' : ''',
    #   #          'callback' : 1,
    #   #          'continuous' : 1,
    #   #          'executable' : 'latexmk',
    #   #          'options' : {
    #   #            '-pdf',
    #   #            '-file-line-error',
    #   #            '-bibtex',
    #   #            '-synctex=1',
    #   #            '-interaction=nonstopmode',
    #   #            '-shell-escape',
    #   #          },
    #   #         }
    # })

    # (luaPlugin {
    #   plugin = rest-nvim;
    #   config = ''
    #     require("rest-nvim").setup({
    #       -- Open request results in a horizontal split
    #       result_split_horizontal = false,
    #       -- Skip SSL verification, useful for unknown certificates
    #       skip_ssl_verification = false,
    #       -- Highlight request on run
    #       highlight = {
    #        enabled = true,
    #        timeout = 150,
    #       },
    #       result = {
    #        -- toggle showing URL, HTTP info, headers at top the of result window
    #        show_url = true,
    #        show_http_info = true,
    #        show_headers = true,
    #        -- disable formatters else they generate errors/add dependencies
    #        -- for instance when it detects html, it tried to run 'tidy'
    #        formatters = {
    #         html = false,
    #         jq = false
    #        },
    #       },
    #       -- Jump to request line on run
    #       jump_to_request = false,
    #     })
    #     '';
    # })

  ];

  filetypePlugins = with pkgs.vimPlugins; [
    { plugin = pkgs.vimPlugins.hurl; }
    { plugin = wmgraphviz-vim; }
    { plugin = fennel-vim; }
    { plugin = vim-toml; }
    { plugin = dhall-vim; }
    { plugin = vim-teal; }
    { plugin = kmonad-vim; }
    moonscript-vim
    idris-vim
  ];
  
  extraPackages = with pkgs; [
     go # for gitlab.nvim, we can probably ditch it afterwards

     nvimLua.pkgs.luarocks

      # luaPackages.lua-lsp
      # lua53Packages.teal-language-server
      # codeium # ideally not needed and referenced by codeium-vim directly
      haskellPackages.hasktags
      haskellPackages.fast-tags

      llm-ls
      manix # should be no need, telescope-manix should take care of it
      nodePackages.vscode-langservers-extracted # needed for typescript language server IIRC
      nodePackages.bash-language-server
      # prettier sadly can't use buildNpmPackage because no lockfile https://github.com/NixOS/nixpkgs/issues/229475
      nodePackages.dockerfile-language-server-nodejs # broken
      nodePackages.typescript-language-server
      # pandoc # for markdown preview, should be in the package closure instead
      # pythonPackages.pdftotext  # should appear only in RC ? broken
      nil # a nix lsp
      # rnix-lsp
      rust-analyzer
      shellcheck
      sumneko-lua-language-server
      yaml-language-server


      # for none-ls
      yamllint
      yamlfmt
      editorconfig-checker # used in null-ls
      lua51Packages.luacheck
      luaformatter
      nodePackages.prettier 
      python3Packages.flake8 # for nvim-lint and some nixpkgs linters
      pkgs.black

      nodePackages.pyright
    ];

    # TODO get lua interpreter to select the good lua packages
    nvimLua = config.programs.neovim.finalPackage.passthru.unwrapped.lua;
 in
{
  programs.neovim = {

   plugins =
           luaPlugins 
        ++ filetypePlugins
        ++ telescopePlugins
        ++ neorgPlugins
   ;

    # plugins = with pkgs.vimPlugins; [
    #  tint-nvim
    # ];
     # -- vim.lsp.set_log_level("info")
     # -- require my own manual config
     # -- logs are written to /home/teto/.cache/vim-lsp.log


    # viml config, to test home-manager setup
    extraConfig = ''
     '';

    extraLuaConfig =  /* lua */ ''
      require('init-manual')
    '';

    extraPython3Packages = p: [ 
     p.jupyter_client
     p.pyperclip  #  if you want to use molten_copy_output
     p.nbformat # to import/export notebooks
     p.pynvim
    ];
    extraPackages = extraPackages;
 };

 home.packages = extraPackages;

}
