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
      icon = "firefox";
      comment = "Firefox for nova";
      terminal = false;
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
    };
    # min = { # minimal definition
    #   exec = "test --option";
    #   name = "Test";
    # };
  };

  programs.ssh.matchBlocks.janssen = {
	user = "janssen";
	port = 2207;
	identityFile = "~/.ssh/nova_key";
	hostname = "data.novinfra.net";
  };

  home.packages =  [
    # pkgs.aws-sam-cli  # BROKEN  for sam lambda
	pkgs.sqlitebrowser
	pkgs.redis # for redis-cli
  ];
}
