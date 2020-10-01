{ config, pkgs, lib,  ... }:
{

  programs.vscode.enable = true;
  programs.vscode = {
    extensions = with pkgs.vscode-extensions;[
      arrterian.nix-env-selector
      bbenoist.Nix
      ms-python.python
      ms-kubernetes-tools.vscode-kubernetes-tools
      # ext install DigitalAssetHoldingsLLC.ghcide
      # ext install BazelBuild.vscode-bazel
    ];
    # haskell.enable = true;
    # haskell.hie.enable = true;
    userSettings = {
      "extensions.autoCheckUpdates" = false;
      "extensions.autoUpdate" = false;
      "update.mode" =  "none";
      "update.channel" = "none";
      "[nix]"."editor.tabSize" = 2;
    }
  };
}
