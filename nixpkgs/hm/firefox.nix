{ config, pkgs, lib,  ... }:
{

  # TODO prefix with stable
  programs.firefox = {
    enable = true;
    # package = unstable.firefox;
    # enableAdobeFlash = false;

    # Not accepted. we should find another way to enable it
    # pass package for instance
    # enableBukubrow = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        nur.repos.rycee.firefox-addons.bitwarden
        nur.repos.rycee.firefox-addons.browserpass
        nur.repos.rycee.firefox-addons.browserpass-otp
        nur.repos.rycee.firefox-addons.dark-night-mode
        nur.repos.rycee.firefox-addons.gesturefy
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
