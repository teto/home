{ config, pkgs, lib, ... }:
{
  programs.neovim = {
    extraPackages = with pkgs; [
      # luaPackages.lua-lsp
      # lua53Packages.teal-language-server
      editorconfig-checker # used in null-ls
      lua51Packages.luacheck
      haskellPackages.hasktags
      haskellPackages.fast-tags
      manix # should be no need, telescope-manix should take care of it
      # nodePackages.vscode-langservers-extracted # needed for typescript language server IIRC
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs # broken
      nodePackages.pyright
      nodePackages.typescript-language-server
      # pandoc # for markdown preview, should be in the package closure instead
      # pythonPackages.pdftotext  # should appear only in RC ? broken
      nil # a nix lsp
      # rnix-lsp
      rust-analyzer
      shellcheck
      sumneko-lua-language-server
      yaml-language-server
    ];
 };
}
