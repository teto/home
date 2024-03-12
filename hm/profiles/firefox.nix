{ config, pkgs, lib, ... }:
let

  defaultFirefoxSettings = {
    # TODO use my own startpage
    "browser.startup.homepage" = "https://github.com/teto";
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

    # breaks facebook messenger when set to false
    "dom.event.clipboardevents.enabled" = true;
    "experiments.activeExperiment" = false;
    "experiments.enabled" = false;
    "experiments.supported" = false;
    "extensions.pocket.enabled" = false;
    "general.smoothScroll" = false;
    "geo.enabled" = false;
    "layout.css.devPixelsPerPx" = "1";
    # "media.navigator.enabled" = false;
    # "media.video_stats.enabled" = false;
    "network.IDN_show_punycode" = true;
    "network.allow-experiments" = false;
    "network.dns.disablePrefetch" = true;
    # "network.http.referer.XOriginPolicy" = 2;
    # "network.http.referer.XOriginTrimmingPolicy" = 2;
    # "network.http.referer.trimmingPolicy" = 1;
    # "network.prefetch-next" = false;
    "permissions.default.shortcuts" = 2; # Don't steal my shortcuts!
    "privacy.donottrackheader.enabled" = true;
    "privacy.donottrackheader.value" = 1;
    # "privacy.firstparty.isolate" = true;
    # "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    # "widget.content.gtk-theme-override" = "Adwaita:light";
  };

  novaFirefoxSettings = {
      # avoid
    "signon.rememberSignons" = false;
  };



  commonExtensions = with pkgs; [
     firefox-addons.bitwarden
     firefox-addons.ublock-origin
     firefox-addons.tree-style-tab
   ];

in
{

  # TODO prefix with stable
  # look at firefox/wrapper to add policies 
  # https://github.com/mozilla/policy-templates#enterprisepoliciesenabled
  programs.firefox = {
    enable = true;
    # import the one in pkgs/
    # package = myFirefox;
    profiles = {
      perso = {
        # https://gitlab.com/rycee/configurations/-/blob/bf46aef74ca53a61fe2d35349fe3dbc6a70b2609/user/firefox.nix#L25-39
        settings = defaultFirefoxSettings;
        path = "q1pprbmm.default";
        # extraConfig = 
        id = 0;
        # Not accepted. we should find another way to enable it
        # pass package for instance
        # with pkgs.nur.repos.rycee.firefox-addons;
        # with pkgs;
        extensions = commonExtensions ++ (with pkgs; [
          # TODO no need for bitwarden anymore
          firefox-addons.browserpass
          firefox-addons."10ten-ja-reader"
          # firefox-addons.audibleTabExtension
          firefox-addons.switch-to-audible-tab
          firefox-addons.browserpass
          firefox-addons.refined-github
          # pkgs.nur.repos.rycee.firefox-addons.browserpass-otp

        ]);

        containersForce = true;
        containers = {
          "shopping" = {
            id = 1;
            color = "blue";
            icon = "cart";
          };
          "dangerous" = {
            id = 2;
            color = "red";
            icon = "fruit";
          };
        };
      };

      bank = lib.mkForce {
        extensions = [];
        # isDefault = false;
        id = 2;
        # path = "6bt2uwrj.nova";
        path = "zwiefm8g.bank";
        settings = {}; 
      };

      # to use with stable-diffusion
      perso-nogpu = {
        settings = defaultFirefoxSettings // { };
        id = 5;
      };

      spam = lib.mkForce {
        # isDefault = false;
        id = 4;
        # path = "6bt2uwrj.nova";
        settings = { };
      };

      nova = lib.mkForce {
        extensions = commonExtensions;
        # isDefault = false;
        id = 1;
        path = "6bt2uwrj.nova";
        settings = novaFirefoxSettings; 
        # let { in { };
      };
    };
  };
}
