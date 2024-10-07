{ pkgs, ... }: {

  i18n.inputMethod = {
    enabled = null;
    # "fcitx5";
    # fcitx5.addons = with pkgs.fcitx-engines;  [ mozc ];
    fcitx5.addons = with pkgs; [ fcitx5-mozc ];
    # fcitx5.waylandFrontend = true;

    inputs = {
      name = "Default";
      defaultLayout = "us";
      defaultIm = "mozc";
      items = [ { name = "keyboard-us"; } { name = "mozc"; } ];
    };
  };

  #   addons = with pkgs.fcitx-engines; [
  #     mozc  # broken
  #     # table-other # for arabic
  #     # table-extra # for arabic
  #     # # hangul
  #     # m17n
  #   ];

  # };
}
