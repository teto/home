{
  config,
  lib,
  pkgs,
  ...
}:
{
  glibcLocales = pkgs.glibcLocales.override {
    allLocales = true;
    locales = [
      "fr_FR.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "ja_JP.utf8"
      # ja_JP
      "ja_JP.eucjp"
      # ja_JP.ujis
      # ja_JP.utf8
    ];
  };

  # defaultLocale = "fr_FR.utf8";
  # "en_US.UTF-8/UTF-8"

  # export LANG=fr_FR.UTF-8  # Example: Set to French
  # supportedLocales
  extraLocaleSettings = { };
}
