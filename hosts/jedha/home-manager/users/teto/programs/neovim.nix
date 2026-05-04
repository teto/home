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

  treesitterPlugins =
    # let
    #   inherit (pkgs.neovimUtils) grammarToPlugin;
    # in
    [
      pkgs.vimPlugins.nvim-treesitter-parsers.nix
      pkgs.vimPlugins.nvim-treesitter-parsers.hurl
    ];

  luaPlugins = with pkgs.vimPlugins; [
    # TODO check that it brings xxd in scope

    # (luaPlugin {
    #  # this is a peculiarly complex one that needs pynvim, image.nvim
    #  plugin = molten-nvim;
    # })

    # (luaPlugin { plugin = nvim-peekup; })  # deno-based markdown preview

    # disabled because of https://github.com/rktjmp/lush.nvim/issues/89
    # (luaPlugin { plugin = lush-nvim; }) # dependency of some colorschemes

    {
      # node-based :MarkdownPreview
      plugin = markdown-preview-nvim;
      type = "viml";
    }

    # (luaPlugin { plugin = minimap-vim; })

    # { plugin = kui-nvim; }
    # FIX https://github.com/NixOS/nixpkgs/issues/169293 first

    # cool but I dont use it
    # (luaPlugin { plugin = stylish-nvim; })

  ];

  # TODO get lua interpreter to select the good lua packages
  # nvimLua = config.programs.neovim.finalPackage.passthru.unwrapped.lua;
in
{
  programs.neovim = {

    # package = flakeSelf.packages.${pkgs.stdenv.hostPlatform.system}.neovim-unwrapped;

    # broken because needs nvim-treesitter-legacy-api
    dap.enable = true;
    neorg.enable = true;

    fennel.enable = true;
    orgmode.enable = true;

    plugins = luaPlugins ++ treesitterPlugins ++ neotestPlugins;

    extraPackages = [
      # pkgs.taplo # a toml LSP server
    ];
  };

}
