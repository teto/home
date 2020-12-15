{ config, lib, pkgs,  ... }:
{

  programs.neovim = {

    enable = false;
    # builtins.trace pkgs.neovim-unwrapped-master.name
    package = pkgs.neovim-unwrapped-master;

	#  source /home/teto/.config/nvim/init.vim
    configure = pkgs.neovimConfigure // {
      customRC = (pkgs.neovimConfigure.customRC  or "") + ''
        let g:fzf_command_prefix = 'Fzf' " prefix commands :Files become :FzfFiles, etc.
        let g:fzf_nvim_statusline = 0 " disable statusline overwriting
      '';

    };

    runtime."ftplugin/bzl.vim".text = ''
      setlocal expandtab
    '';

    runtime."ftplugin/c.vim".text = ''
      " otherwise vim defaults to ccomplete#Complete
      setlocal omnifunc=v:lua.vim.lsp.omnifunc

    '';


    # cp $(nix-build -A tree-sitter.builtGrammars."$lang" ~/nixpkgs)/parser config/nvim/parser/${lang}.so
    runtime."parser/c.so".source = "${pkgs.tree-sitter.builtGrammars.c}/parser";
    runtime."parser/bash.so".source = "${pkgs.tree-sitter.builtGrammars.bash}/parser";

    # customRC = ''
    #   set hidden
    # '';


	# cp $(nix-build -A tree-sitter.builtGrammars."$lang" ~/nixpkgs)/parser config/nvim/parser/${lang}.so
    # parsers = [ tree-sitter.builtGrammars.c ];
    # runtime."parsers/C.so" = 

  };

}
