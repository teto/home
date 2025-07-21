{
  config,
  pkgs,
  lib,
  flakeSelf,
  ...
}:
let

  # reference flakeSelf instead ?
  nvimLib = pkgs.callPackages ../../../../../../hm/profiles/neovim/lib.nix { };

  inherit (nvimLib) luaPlugin;

  # try via rocks.nvim first
  neotestPlugins = with pkgs.vimPlugins; [
    # neotest
    # neotest-haskell
  ];

  treesitterPlugins = with pkgs.vimPlugins; [
    pkgs.vimPlugins.nvim-treesitter-parsers.nix
    pkgs.vimPlugins.nvim-treesitter-parsers.hurl
  ];

  luaPlugins = with pkgs.vimPlugins; [
    # pkgs.vimPlugins.vim-nixhash # :NixHash
    # pkgs.vimPlugins.targets-vim # to get 'ci/'
    # TODO check that it brings xxd in scope
    # pkgs.vimPlugins.hex-nvim

    # should bring in scope fzy
    # (luaPlugin { plugin = nvim-ufo; })
    # (luaPlugin { plugin = nvim-dbee; })

    # testin
    # TODO restore
    # (luaPlugin { plugin = image-nvim; })

    # (luaPlugin {
    #  # this is a peculiarly complex one that needs pynvim, image.nvim
    #  plugin = molten-nvim;
    # })

    # TODO should be able to handle it via rocks ?
    # avante lets you use neovim as cursor IDE
    # (luaPlugin { plugin = avante-nvim; })

    # I've not been using it so far
    # (luaPlugin { plugin = nvim-dap; })

    # (luaPlugin {
    #   # TODO move config hee
    #   plugin = bufferline-nvim;
    # })

    # (luaPlugin { plugin = nvim-peekup; })  # deno-based markdown preview

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

    {
      # node-based :MarkdownPreview
      plugin = markdown-preview-nvim;
      # let g:vim_markdown_preview_github=1
      # let g:vim_markdown_preview_use_xdg_open=1
    }
    (luaPlugin { plugin = minimap-vim; })

    # { plugin = kui-nvim; }
    # FIX https://github.com/NixOS/nixpkgs/issues/169293 first

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

    # cool but I dont use it
    # (luaPlugin { plugin = stylish-nvim; })

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

    # (luaPlugin { plugin = minimap-vim; })

    # (luaPlugin { plugin = rest-nvim; })
  ];

  filetypePlugins = with pkgs.vimPlugins; [
  ];

  # (luaPlugin { plugin = telescope-nvim; })

  # TODO get lua interpreter to select the good lua packages
  nvimLua = config.programs.neovim.finalPackage.passthru.unwrapped.lua;
in
{
  programs.neovim = {

    plugins =
      luaPlugins
      ++ filetypePlugins
      ++ treesitterPlugins
      # ++ telescopePlugins
      ++ neotestPlugins;

    extraPackages = [
      # pkgs.taplo # a toml LSP server
    ];
  };

  # home.packages = extraPackages;
}
