{
  config,
  pkgs,
  flakeSelf,
  ...
}:
{

  imports = [
    ./programs/bash.nix
    ./ssh-config.nix
    ./programs/firefox.nix
    # flakeSelf.inputs.jinko-seeder.homeModules.jinko-seeder

    # TODO improve that
    flakeSelf.inputs.nova-doctor.homeModules.browsers

  ];

  programs.git = {
    includes = [
      # { path = config.xdg.configHome + "/git/config.inc"; }
      # everything under ~/yourworkfolder/ is company code, so use the other user/email/gpg key, etc
      {
        # path = ./resources/gitconfigwork;
        path = config.xdg.configHome + "/git/config.nova.inc";
        condition = "gitdir:~/nova/";
      }
    ];
  };

  home.packages = [
    # flakeSelf.inputs.jinko-seeder.packages.${pkgs.system}.jinko-seeder

    pkgs.aws-vault-nova # wrap aws-vault with some specific variables
    pkgs.sqlitebrowser
    # pkgs.google-chrome
    # pigz for zlib (de)compression

    # for my yazi plugin
    pkgs.pigz # pigz -d ~/nova/jinko2/ScalarMetaDataChunked.json.zlib -c
    pkgs.openapi-tui # explore openapi spec in terminal

    pkgs.yq # required for bin/start_psql.sh
  ];

  # to counter doctor's config of starship
  xdg.configFile."starship.toml".enable = false;

  # xdg.configFile."nix/nix.conf".enable = false;

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
      comment = "Firefox (nova)";
      terminal = false;
      name = "Firefox (nova)";
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
