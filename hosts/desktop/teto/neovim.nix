{ config, pkgs, lib, ... }:
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

  luaPlugins = with pkgs.vimPlugins; [
    { plugin = b64-nvim; }
    { plugin = kui-nvim; }
    # FIX https://github.com/NixOS/nixpkgs/issues/169293 first
    (luaPlugin {
      plugin = telescope-frecency-nvim; 
      config = ''
       require'telescope'.load_extension('frecency')
       '';
    })
    (luaPlugin {
      plugin = nvimdev-nvim;
      optional = true;
      config = ''
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
    (luaPlugin { plugin = telescope-manix; })
    # call with :Hoogle
        (luaPlugin { plugin = glow-nvim; })

    (luaPlugin {
      plugin = fzf-hoogle-vim;
      config = ''
       vim.g.hoogle_path = "hoogle"
       vim.g.hoogle_fzf_cache_file = vim.fn.stdpath('cache')..'/hoogle_cache.json'
       '';
    })
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
    (luaPlugin { plugin = nvim-telescope-zeal-cli; })
    (luaPlugin { plugin = minimap-vim; })
    (luaPlugin {
      # reuse once https://github.com/neovim/neovim/issues/9390 is fixed
      plugin = vimtex;
      optional = true;
      config = ''
        -- Pour le rappel
        -- <localleader>ll pour la compilation continue du pdf
        -- <localleader>lv pour la preview du pdf
        -- see https://github.com/lervag/vimtex/issues/1058
        -- let g:vimtex_log_ignore 
        -- taken from https://castel.dev/post/lecture-notes-1/
        vim.g.tex_conceal='abdmg'
        vim.g.vimtex_log_verbose=1
        vim.g.vimtex_quickfix_open_on_warning = 1
        vim.g.vimtex_view_automatic=1
        vim.g.vimtex_view_enabled=1
        -- was only necessary with vimtex lazy loaded
        -- let g:vimtex_toc_config={}
        -- let g:vimtex_complete_img_use_tail=1
        -- autoindent can slow down vim quite a bit
        -- to check indent parameters, run :verbose set ai? cin? cink? cino? si? inde? indk?
        vim.g.vimtex_indent_enabled=0
        vim.g.vimtex_indent_bib_enabled=1
        vim.g.vimtex_compiler_enabled=1
        vim.g.vimtex_compiler_progname='nvr'
        vim.g.vimtex_quickfix_method="latexlog"
        -- 1=> opened automatically and becomes active (2=> inactive)
        vim.g.vimtex_quickfix_mode = 2
        vim.g.vimtex_indent_enabled=0
        vim.g.vimtex_indent_bib_enabled=1
        vim.g.vimtex_view_method = 'zathura'
        vim.g.vimtex_format_enabled = 0
        vim.g.vimtex_complete_recursive_bib = 0
        vim.g.vimtex_complete_close_braces = 0
        vim.g.vimtex_fold_enabled = 0
        vim.g.vimtex_view_use_temp_files=1 -- to prevent zathura from flickering
        -- let g:vimtex_syntax_minted = [ { 'lang' : 'json', \ }]

        -- shell-escape is mandatory for minted
        -- check that '-file-line-error' is properly removed with pplatex
        -- executable The name/path to the latexmk executable. 
        '';
      # vim.gvimtex_compiler_latexmk = {
      #          'backend' : 'nvim',
      #          'background' : 1,
      #          'build_dir' : ''',
      #          'callback' : 1,
      #          'continuous' : 1,
      #          'executable' : 'latexmk',
      #          'options' : {
      #            '-pdf',
      #            '-file-line-error',
      #            '-bibtex',
      #            '-synctex=1',
      #            '-interaction=nonstopmode',
      #            '-shell-escape',
      #          },
      #         }
    })

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
    moonscript-vim
    idris-vim
  ];

 in
{
  programs.neovim = {

   plugins = luaPlugins ++ filetypePlugins;

    # plugins = with pkgs.vimPlugins; [
    #  tint-nvim
    # ];
     extraLuaConfig = ''
       -- logs are written to /home/teto/.cache/vim-lsp.log
       -- vim.lsp.set_log_level("info")
       -- require my own manual config
       require('init-manual')
     '';

    extraPackages = with pkgs; [
      # luaPackages.lua-lsp
      # lua53Packages.teal-language-server
      editorconfig-checker # used in null-ls
      lua51Packages.luacheck
      haskellPackages.hasktags
      haskellPackages.fast-tags
      manix # should be no need, telescope-manix should take care of it
      nodePackages.vscode-langservers-extracted # needed for typescript language server IIRC
      nodePackages.bash-language-server
      # prettier sadly can't use buildNpmPackage because no lockfile https://github.com/NixOS/nixpkgs/issues/229475
      nodePackages.prettier 
      nodePackages.dockerfile-language-server-nodejs # broken
      nodePackages.pyright
      nodePackages.typescript-language-server
      # pandoc # for markdown preview, should be in the package closure instead
      # pythonPackages.pdftotext  # should appear only in RC ? broken
      python3Packages.flake8 # for nvim-lint and some nixpkgs linters
      nil # a nix lsp
      # rnix-lsp
      rust-analyzer
      shellcheck
      sumneko-lua-language-server
      yaml-language-server
    ];

 };
}
