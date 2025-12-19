{
  config,
  pkgs,
  lib,
  flakeSelf,
  ...
}:
let

  # reference flakeSelf instead ?
  # todo reference pkgs.neovimLib instead?
  nvimLib = lib.neovim;

  inherit (nvimLib) luaPlugin;

  # try via rocks.nvim first
  neotestPlugins = [
    # neotest
    # neotest-haskell
  ];

  treesitterPlugins = let 
      inherit (pkgs.neovimUtils) grammarToPlugin;
    in [
    pkgs.vimPlugins.nvim-treesitter-parsers.nix
    pkgs.vimPlugins.nvim-treesitter-parsers.hurl
  ];

  luaPlugins = with pkgs.vimPlugins; [
    pkgs.vimPlugins.neorg
    # pkgs.vimPlugins.vim-nixhash # :NixHash
    # TODO check that it brings xxd in scope
    # pkgs.vimPlugins.hex-nvim

    # should bring in scope fzy
    # (luaPlugin { plugin = nvim-ufo; })
    # (luaPlugin { plugin = nvim-dbee; })

    # (luaPlugin {
    #  # this is a peculiarly complex one that needs pynvim, image.nvim
    #  plugin = molten-nvim;
    # })

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

    # (luaPlugin {
    #   plugin = fzf-hoogle-vim;
    #   config = ''
    #    vim.g.hoogle_path = "hoogle"
    #    vim.g.hoogle_fzf_cache_file = vim.fn.stdpath('cache')..'/hoogle_cache.json'
    #    '';
    # })

    # cool but I dont use it
    # (luaPlugin { plugin = stylish-nvim; })

  ];

  filetypePlugins = with pkgs.vimPlugins; [
  ];

  # (luaPlugin { plugin = telescope-nvim; })

  # TODO get lua interpreter to select the good lua packages
  nvimLua = config.programs.neovim.finalPackage.passthru.unwrapped.lua;
in
{
  programs.neovim = {

    package = lib.mkForce flakeSelf.inputs.neovim-nightly-overlay.packages."${pkgs.stdenv.hostPlatform.system}".neovim-debug;

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

}
