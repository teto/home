{ config, lib, pkgs,  ... }:
let
in
{
  xdg.desktopEntries = {
  # xdg.desktopEntries = {
  #     min = { # minimal definition
  #       exec = "firefox -p nova";
  #       name = "Firefox for nova";
  #     };
  # };


    full = { # full definition
      type = "Application";
      exec = "firefox -p nova";
      icon = "test";
      comment = "Firefox for nova";
      terminal = true;
      name = "Firefox for nova";
      genericName = "Web Browser";
      mimeType = [ "text/html" "text/xml" ];
      categories = [ "Network" "WebBrowser" ];
      startupNotify = false;
      # extraConfig = ''
      #   [X-ExtraSection]
      #   Exec=foo -o
      # '';
      # settings = {
      #   Keywords = "calc;math";
      #   DBusActivatable = "false";
      # };
      fileValidation = true;
    };
    # min = { # minimal definition
    #   exec = "test --option";
    #   name = "Test";
    # };
  };

  home.packages =  [
    # pkgs.aws-sam-cli  # BROKEN  for sam lambda
  ];
}
