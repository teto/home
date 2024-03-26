{ config, lib, pkgs, ... }:
{

  imports = [
      ./nova/bash.nix
  ];

  programs.bash.shellAliases = {
     sscwl = "nix run .#simwork.core-webservice.local -- --bypass-manifest-check -vv";
  };

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
    };
    # min = { # minimal definition
    #   exec = "test --option";
    #   name = "Test";
    # };
  };


  home.packages = [
    pkgs.aws-vault # set it up as 
    pkgs.sqlitebrowser
    pkgs.google-chrome
  ];
}
