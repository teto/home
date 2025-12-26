# just a very basic neovim profile to avoid putting a too big closure
{
  pkgs,
  lib,
  flakeSelf,
  ...
}:

let

  inherit (lib)
    genBlockLua
    ;

  luaRcBlocks = {
    appearance = ''
      -- draw a line on 80th column
      vim.o.colorcolumn='80,100'
    '';

    # hi MsgSeparator ctermbg=black ctermfg=white
    # TODO equivalent of       set fillchars+=
    foldBlock = ''
      vim.o.fillchars='foldopen:▾,foldclose:▸,msgsep:‾'
      vim.o.foldcolumn='auto:2'
    '';
  };

  pluginsMap = pkgs.callPackage ./plugins.nix { inherit flakeSelf lib; };

  myNeovimUnwrapped =
    flakeSelf.inputs.neovim-nightly-overlay.packages."${pkgs.stdenv.hostPlatform.system}".neovim;
  # nvimLua = config.programs.neovim.finalPackage.passthru.unwrapped.lua;

  rawPlugins =
    # add grepper
    pluginsMap.basePlugins
  # ++ pluginsMap.luaPlugins
  # ++ pluginsMap.filetypePlugins
  ;

in
{

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    enableMyDefaults = true;
    highlightOnYank = true;

    # custom options
    # autocompletion.enable = true;
    # TODO ?
    # snippets.enable = true;

    # take the one from the flake
    package = myNeovimUnwrapped;

    extraLuaConfig = lib.mkBefore (
      ''
        vim.g.mapleader = ' '
        vim.opt.hidden = true -- you can open a new buffer even if current is unsaved (error E37) =
      ''
      + (lib.strings.concatStrings (lib.mapAttrsToList genBlockLua luaRcBlocks))
      + ''
        vim.opt.number = true
        vim.opt.relativenumber = true
      ''
    );

    extraConfig = ''
      set shiftwidth=4
      set expandtab
      set autoindent
      filetype plugin indent on

      autocmd FileType tex setlocal shiftwidth=2 textwidth=79
      autocmd FileType nix setlocal shiftwidth=2
    '';

    extraPackages = [ ];

    plugins = map (x: builtins.removeAttrs x [ "after" ]) rawPlugins;
  };

}
