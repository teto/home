{ config, pkgs, lib,  ... }:

let
  # TODO pass extraMakeWrapperArgs
  neovim-xp = pkgs.wrapNeovim pkgs.neovim-unwrapped-master {
    # TODO pass lua-lsp
    # extraMakeWrapperArgs = " --prefix PATH ${pkgs.}"
    structuredConfigure = pkgs.neovimDefaultConfig;
  };
in
{
  home.packages = [
    neovim-xp
  ];

  home.file."${config.xdg.configHome}/nvim/parser/c.so".source = "${pkgs.tree-sitter.builtGrammars.c}/parser";
  home.file."${config.xdg.configHome}/nvim/parser/bash.so".source = "${pkgs.tree-sitter.builtGrammars.bash}/parser";

  # programs.neovim = {
  #   enable = true;
  #   package = ;
  # };


}

