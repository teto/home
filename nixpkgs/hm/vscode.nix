{ config, pkgs, lib,  ... }:
{

  programs.vscode.enable = true;
  programs.vscode = {
    extensions = with pkgs.vscode-extensions;[
      bbenoist.Nix
      ms-python.python
      ms-kubernetes-tools.vscode-kubernetes-tools
      # ext install DigitalAssetHoldingsLLC.ghcide
      # ext install BazelBuild.vscode-bazel
    ];
    # haskell.enable = true;
    # haskell.hie.enable = true;
  };
}
