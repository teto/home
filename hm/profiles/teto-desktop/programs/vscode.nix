{ pkgs, ... }:
{
  enable = false;
  profiles = {
    # https://marketplace.visualstudio.com/items?itemName=rheller.alive
    default.extensions = with pkgs.vscode-extensions; [
      # asvetliakov.vscode-neovim # only in my fork
      # todo replace with pylance/pyright
      # ms-kubernetes-tools.vscode-kubernetes-tools
      # ms-vsliveshare.vsliveshare
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
