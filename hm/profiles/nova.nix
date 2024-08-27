{
  config,
  lib,
  pkgs,
  ...
}:
{

  imports = [ ./nova/programs/bash.nix ];

  home.packages = [
    pkgs.aws-vault-nova # wrap aws-vault with some specific variables
    pkgs.sqlitebrowser
    pkgs.google-chrome
    # pigz for zlib (de)compression
    pkgs.pigz # pigz -d ~/nova/jinko2/ScalarMetaDataChunked.json.zlib -c
    pkgs.openapi-tui # explore openapi spec in terminal
  ];

  # to counter doctor's config of starship
  xdg.configFile."starship.toml".enable = false;

  xdg.desktopEntries = {
    # xdg.desktopEntries = {
    #     min = { # minimal definition
    #       exec = "firefox -p nova";
    #       name = "Firefox for nova";
    #     };
    # };
    full = {
      # full definition
      # https://superuser.com/questions/1179843/how-to-start-a-firefox-with-a-different-wm-class-or-any-other-altered-property
      type = "Application";
      exec = "firefox -p nova --class firefox-nova";
      icon = "firefox";
      comment = "Nova (firefox)";
      terminal = false;
      name = "nova (Firefox)";
      genericName = "Web Browser";
      mimeType = [
        "text/html"
        "text/xml"
      ];
      categories = [
        "Network"
        "WebBrowser"
      ];
      startupNotify = false;
      # extraConfig = ''
      #   [X-ExtraSection]
      #   Exec=foo -o
      # '';
      # settings = {
      #   Keywords = "calc;math";
      #   DBusActivatable = "false";
      # };
    };
    # min = { # minimal definition
    #   exec = "test --option";
    #   name = "Test";
    # };
  };
}
