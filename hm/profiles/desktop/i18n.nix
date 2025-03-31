{ pkgs, ... }:
{
  inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-mozc # currently broken
      ];

      waylandFrontend = true;
    };

    # inputs = {
    #   name = "Default";
    #   defaultLayout = "us";
    #   defaultIm = "mozc";
    #   items = [
    #     { name = "keyboard-us"; }
    #     { name = "mozc"; }
    #   ];
    # };
  };

  glibcLocales = pkgs.glibcLocales.override {
    allLocales = true;
    # 229 fr_FR.UTF-8/UTF-8 \
    # 230 fr_FR/ISO-8859-1 \
    # 231 fr_FR@euro/ISO-8859-15 \
    locales = [
      "fr_FR.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "jp_JP.UTF-8/UTF-8"
    ];
  };

}
