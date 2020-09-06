{ config, pkgs, lib,  ... }:
let

#  nur = import (builtins.fetchTarball {
#    # TODO pass rev
#    url = "https://github.com/nix-community/NUR/archive/358dfac85d647bd3e0b30aa76c2b63d203233419.tar.gz";
#    # url = "https://github.com/nix-community/NUR/archive/cb0033ca5ef1e2db7952919f0f983ce57d8526b0.tar.gz";
#    sha256 = "1xm2z8f7zhwdzwasy348ilk4850i71s98jrhqhjrmaanhc0p67nl";
#  }) {
#    inherit pkgs;
#  };
in
{

  # TODO prefix with stable
  programs.firefox = {
    enable = true;
    # package = unstable.firefox;
    # enableAdobeFlash = false;

    # Not accepted. we should find another way to enable it
    # pass package for instance
    # enableBukubrow = true;
    # with pkgs.nur.repos.rycee.firefox-addons;
    extensions =  with pkgs;[
#        nur.repos.rycee.firefox-addons.bitwarden
#        nur.repos.rycee.firefox-addons.browserpass
#        nur.repos.rycee.firefox-addons.browserpass-otp
#        nur.repos.rycee.firefox-addons.dark-night-mode
#        nur.repos.rycee.firefox-addons.gesturefy
    ];

    profiles = {
      default =  {
        isDefault = true;
        settings = {
          "browser.startup.homepage" = "https://nixos.org";
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

      nova = {
        id = 1;
        path = "6bt2uwrj.nova";
        settings = {};
      };
    };
  };
}
