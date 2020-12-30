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
      (pkgs.fetchFirefoxAddon {
        name = "rikaichamp";
        url = "https://addons.mozilla.org/firefox/downloads/file/3691333/rikaichamp-0.3.3-fx.xpi";
        sha256 = "sha256-wFW5E7Ewux8ZbKCZXshQaOQojyim7zpsDgrLPAAnFL8=";
      })
       nur.repos.rycee.firefox-addons.browserpass
#        nur.repos.rycee.firefox-addons.browserpass-otp
       nur.repos.rycee.firefox-addons.dark-night-mode
       # nur.repos.rycee.firefox-addons.tree-style-tabs
#        nur.repos.rycee.firefox-addons.gesturefy
# tree-style-tab
    ];

    profiles = {
      perso =  {
        # https://gitlab.com/rycee/configurations/-/blob/bf46aef74ca53a61fe2d35349fe3dbc6a70b2609/user/firefox.nix#L25-39
        settings = {
          # TODO use my own startpage
          "browser.startup.homepage" = "https://github.com";
          "browser.search.region" = "FR";
          "browser.search.isUS" = false;
          # "distribution.searchplugins.defaultLocale" = "en-GB";
          # "general.useragent.locale" = "en-GB";
          # "browser.bookmarks.showMobileBookmarks" = true;

          "beacon.enabled" = false;
          "browser.display.background_color" = "#c5c8c6";
          "browser.display.foreground_color" = "#1d1f21";
          "browser.safebrowsing.appRepURL" = "";
          "browser.safebrowsing.malware.enabled" = false;
          "browser.search.hiddenOneOffs" =
            "Google,Yahoo,Bing,Amazon.com,Twitter";
          "browser.search.suggest.enabled" = false;
          "browser.send_pings" = false;
          "browser.startup.page" = 3;
          "browser.tabs.closeWindowWithLastTab" = false;
          "browser.urlbar.placeholderName" = "DuckDuckGo";
          "browser.urlbar.speculativeConnect.enabled" = false;
          # "devtools.theme" = "${config.theme.base16.kind}";
          "dom.battery.enabled" = false;
          "dom.event.clipboardevents.enabled" = false;
          "experiments.activeExperiment" = false;
          "experiments.enabled" = false;
          "experiments.supported" = false;
          "extensions.pocket.enabled" = false;
          "general.smoothScroll" = false;
          "geo.enabled" = false;
          "layout.css.devPixelsPerPx" = "1";
          "media.navigator.enabled" = false;
          "media.video_stats.enabled" = false;
          "network.IDN_show_punycode" = true;
          "network.allow-experiments" = false;
          "network.dns.disablePrefetch" = true;
          "network.http.referer.XOriginPolicy" = 2;
          "network.http.referer.XOriginTrimmingPolicy" = 2;
          "network.http.referer.trimmingPolicy" = 1;
          "network.prefetch-next" = false;
          "permissions.default.shortcuts" = 2; # Don't steal my shortcuts!
          "privacy.donottrackheader.enabled" = true;
          "privacy.donottrackheader.value" = 1;
          "privacy.firstparty.isolate" = true;
          # "signon.rememberSignons" = false;
          # "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          # "widget.content.gtk-theme-override" = "Adwaita:light";
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
