{ pkgs }:
{
  commonPolicies = {

    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;
    DisableFirefoxStudies = true;

    DisableTelemetry = true;
    DisplayMenuBar = "default-off";
  };


  searchEngines = {
    "Jisho" = {
      urls = [
        {
          template = "https://jisho.org/search/{searchTerms}";
          params = [
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      # icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@ji" ];
    };

    "youtube" = {
      urls = [
        {
          # 
          template = "https://www.youtube.com/results?search_query={searchTerms}";
          params = [
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      # icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@yt" ];
    };

    "Nix Packages" = {
      urls = [
        {
          template = "https://search.nixos.org/packages";
          params = [
            {
              name = "type";
              value = "packages";
            }
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@np" ];
    };
    # it has no search engine yet :'(
    # "Nixpkgs manual" = {
    #   urls = [ { template = "https://nixos.org/manual/nixpkgs/stable?search={searchTerms}"; } ];
    #   icon = "https://nixos.wiki/favicon.png";
    #   updateInterval = 24 * 60 * 60 * 1000; # every day
    #   definedAliases = [ "@nm" ];
    # };
    "NixOS Wiki" = {
      urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
      icon = "https://nixos.wiki/favicon.png";
      updateInterval = 24 * 60 * 60 * 1000; # every day
      definedAliases = [ "@nw" ];
    };

    hoogle = {
      urls = [
        {
          template = "https://hoogle.haskell.org";
          params = [
            {
              name = "hoogle";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      definedAliases = [
        "@ho"
        "@hg"
      ];
    };
    "bing".metaData.hidden = true;
    "google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
  };

  # https://discourse.nixos.org/t/how-do-you-pin-a-firefox-extensions-add-on-to-the-firefox-toolbar/36081
  # browser.uiCustomization.state
  myDefaultSettings = {

    # to avoid all those freaking advised article
    "browser.newtabpage.activity-stream.feeds.section.topstories" = "false";

    # TODO use my own startpage
    "browser.startup.homepage" = "https://github.com/teto";
    "browser.search.region" = "FR";
    "browser.search.isUS" = false;
    # "distribution.searchplugins.defaultLocale" = "en-GB";
    # "general.useragent.locale" = "en-GB";
    # "browser.bookmarks.showMobileBookmarks" = true;

    "beacon.enabled" = false;
    # "browser.aboutConfig.showWarning" = false;
    "browser.cache.disk.enable" = false; # Be kind to hard drive

    # this makes many sites unreadable
    # "browser.display.background_color" = "#c5c8c6";
    # "browser.display.foreground_color" = "#1d1f21";

    "browser.safebrowsing.appRepURL" = "";
    "browser.safebrowsing.malware.enabled" = false;

    "browser.search.hiddenOneOffs" = "Google,Yahoo,Bing,Amazon.com,Twitter";
    "browser.search.suggest.enabled" = false;

    "browser.translations.neverTranslateLanguages" = "en";
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

    "browser.urlbar.showSearchSuggestionsFirst" = false;
    "browser.urlbar.suggest.bookmark" = true;

    "sidebar.revamp" = true;
    "sidebar.verticalTabs" = true;

    "mousewheel.default.delta_multiplier_x" = 20;
    "mousewheel.default.delta_multiplier_y" = 20;
    "mousewheel.default.delta_multiplier_z" = 20;

    "browser.send_pings" = false;

    "browser.startup.page" = 3;
    "browser.tabs.closeWindowWithLastTab" = false;
    "browser.tabs.hoverpreview.enabled" = true;
    "browser.tabs.maxOpenBeforeWarn" = 5;

    "browser.urlbar.placeholderName" = "DuckDuckGo";
    "browser.urlbar.speculativeConnect.enabled" = false;
    # "devtools.theme" = "${config.theme.base16.kind}";
    "dom.battery.enabled" = false;

    "layout.spellcheckDefault" = 0;

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
    "media.autoplay.block-event.enabled" = true;
    # "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" =  true;
    "network.IDN_show_punycode" = true;
    "network.allow-experiments" = false;

    "network.dns.disablePrefetch" = false;
    # "network.prefetch-next" = false;

    # "network.http.referer.XOriginPolicy" = 2;
    # "network.http.referer.XOriginTrimmingPolicy" = 2;
    # "network.http.referer.trimmingPolicy" = 1;
    "permissions.default.shortcuts" = 2; # Don't steal my shortcuts!

    "privacy.donottrackheader.enabled" = true;
    "privacy.donottrackheader.value" = 1;
    # "privacy.firstparty.isolate" = true;
    # "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    # "widget.content.gtk-theme-override" = "Adwaita:light";

    "widget.use-xdg-desktop-portal.file-picker" = 1;

    # "general.config.filename" =

    # TO avoid
    "signon.prefillForms" = true;
    # "signon.rememberSignons" = false;
  };

  commonExtensions = with pkgs; [
    firefox-addons.bitwarden
    firefox-addons.ublock-origin
    firefox-addons.tree-style-tab
  ];

}
