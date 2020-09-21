{ config, lib, pkgs,  ... }:
{

  programs.neovim = {

    enable = true;
    package = builtins.trace pkgs.neovim-unwrapped-master.name pkgs.neovim-unwrapped-master;
    runtime."ftplugin/bzl.vim".text = ''
      setlocal expandtab
    '';

    runtime."ftplugin/c.vim".text = ''
      " otherwise vim defaults to ccomplete#Complete
      setlocal omnifunc=v:lua.vim.lsp.omnifunc
    '';


	# cp $(nix-build -A tree-sitter.builtGrammars."$lang" ~/nixpkgs)/parser config/nvim/parser/${lang}.so
    # parsers = [ tree-sitter.builtGrammars.c ];
    # runtime."parsers/C.so" = 

  };

}
