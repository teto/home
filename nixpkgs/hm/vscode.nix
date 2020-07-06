{ config, pkgs, lib,  ... }:
{

  programs.vscode.enable = true;
  programs.vscode = {
    extensions = with pkgs.vscode-extensions;[
      bbenoist.Nix
      ms-python.python
      ms-kubernetes-tools.vscode-kubernetes-tools
    ];
    haskell.enable = true;
    haskell.hie.enable = true;
  };
}
