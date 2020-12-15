{ config, pkgs, lib,  ... }:
let

 # nur = import (builtins.fetchTarball {
 #   # TODO pass rev
 #   url = "https://github.com/nix-community/NUR/archive/358dfac85d647bd3e0b30aa76c2b63d203233419.tar.gz";
 #   # url = "https://github.com/nix-community/NUR/archive/cb0033ca5ef1e2db7952919f0f983ce57d8526b0.tar.gz";
 #   sha256 = "1xm2z8f7zhwdzwasy348ilk4850i71s98jrhqhjrmaanhc0p67nl";
 # }) {
 #   inherit pkgs;
 # };

in
{

  # TODO prefix with stable
  programs.firefox = {
    enable = true;
    # import the one in pkgs/
    # package = myFirefox;
    # enableAdobeFlash = false;

    # Not accepted. we should find another way to enable it
    # pass package for instance
    # enableBukubrow = true;
    # with pkgs.nur.repos.rycee.firefox-addons;
    extensions =  with pkgs;[
      # TODO no need for bitwarden anymore
      pkgs.nur.repos.rycee.firefox-addons.bitwarden

      (pkgs.fetchFirefoxAddon {
        name = "ublock";
        url = "https://addons.mozilla.org/firefox/downloads/file/3679754/ublock_origin-1.31.0-an+fx.xpi";
        sha256 = "1h768ljlh3pi23l27qp961v1hd0nbj2vasgy11bmcrlqp40zgvnr";
      })
#        nur.repos.rycee.firefox-addons.browserpass
#        nur.repos.rycee.firefox-addons.browserpass-otp
#        nur.repos.rycee.firefox-addons.dark-night-mode
#        nur.repos.rycee.firefox-addons.gesturefy
    ];

    profiles = {
      perso =  {
        settings = {
          # TODO use my own startpage
          "browser.startup.homepage" = "https://github.com";
          "browser.search.region" = "FR";
          "browser.search.isUS" = false;
          # "distribution.searchplugins.defaultLocale" = "en-GB";
          # "general.useragent.locale" = "en-GB";
          # "browser.bookmarks.showMobileBookmarks" = true;
        };
        path = "q1pprbmm.default";
        # extraConfig = 
        id = 0;
      };

      nova = lib.mkForce {
        # isDefault = false;
        id = 1;
        path = "6bt2uwrj.nova";
        settings = {};
      };
    };
  };
}
