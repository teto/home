{ config, pkgs, lib, ... }:
{

  programs.vscode.enable = true;
  programs.vscode = {
    extensions = with pkgs.vscode-extensions;[
      # arrterian.nix-env-selector # not packaged ?
      # https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim
      # asvetliakov.vscode-neovim # only in my fork
      # todo replace with pylance/pyright
      # ms-kubernetes-tools.vscode-kubernetes-tools
      ms-vsliveshare.vsliveshare
    ];
    # userSettings = {
    #   "extensions.autoCheckUpdates" = false;
    #   "extensions.autoUpdate" = false;
    #   "update.mode" =  "none";
    #   "update.channel" = "none";
    #   "[nix]"."editor.tabSize" = 2;
    # };
  };
}
