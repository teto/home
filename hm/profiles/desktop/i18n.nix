{ pkgs, ... }:
{
  inputMethod = {
    enabled = "fcitx5";
    # fcitx5.addons = with pkgs.fcitx-engines;  [ mozc ];
    fcitx5.addons = with pkgs; [ fcitx5-mozc ];
    # fcitx5.waylandFrontend = true;
  };
}
