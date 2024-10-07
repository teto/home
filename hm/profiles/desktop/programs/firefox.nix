{
  config,
  pkgs,
  lib,
  ...
}:
let

  # https://discourse.nixos.org/t/how-do-you-pin-a-firefox-extensions-add-on-to-the-firefox-toolbar/36081
  # browser.uiCustomization.state 
  myDefaultSettings = {
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

    "browser.display.background_color" = "#c5c8c6";
    "browser.display.foreground_color" = "#1d1f21";

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

  novaSpecificSettings = {
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
  # programs.firefox = {
  enable = true;
  # import the one in pkgs/
  # package = myFirefox;
  languagePacks = [
    "fr-FR"
    "jp-JP"
    "en-GB"
    # 5840
  ];
  # check about:policies
  policies = {
    BlockAboutConfig = false;
    AppAutoUpdate = true;

    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;

    # DefaultDownloadDirectory
    DisableFirefoxStudies = true;
    # DisableFormHistory;
    DisablePocket = true;
    DisableTelemetry = true;
    DisplayMenuBar = "default-off";
    HardwareAcceleration = true;
    # buggy see https://github.com/nix-community/home-manager/issues/5821
    NoDefaultBookmarks = true;
    # OfferToSaveLoginsDefault = 
    # TranslateEnabled = 
    PDFjs = false;
    Bookmarks = { };
#  "type": "array",
#  "items": {
#   "type": "object",
#   "properties": {
#    "Title": {
#     "type": "string"
#    },
#    "URL": {
#     "type": "URL"
#    },
#    "Favicon": {
#     "type": "URLorEmpty"
#    },
#    "Placement": {
#     "type": "string",
#     "enum": [
#      "toolbar",
#      "menu"
#     ]
#    },
#    "Folder": {
#     "type": "string"
#    }
#   },
#   "required": [
#    "Title",
#    "URL"
#   ]
#  }
# }
    # DefaultDownloadDirectory = "\${home}/Downloads";
  };
  nativeMessagingHosts = [
    # add it to firefox-addons. ?
    pkgs.ff2mpv
  ];
  profiles = {
    perso = {
      # https://gitlab.com/rycee/configurations/-/blob/bf46aef74ca53a61fe2d35349fe3dbc6a70b2609/user/firefox.nix#L25-39
      settings = myDefaultSettings;
      path = "q1pprbmm.default";
      # extraConfig = 
      id = 0;
      # Not accepted. we should find another way to enable it
      # pass package for instance
      # with pkgs.nur.repos.rycee.firefox-addons;
      # with pkgs;

      # pkgs.open-in-mpv
      extensions =
        commonExtensions
        ++ (with pkgs; [
          # TODO no need for bitwarden anymore
          firefox-addons.browserpass
          firefox-addons."10ten-ja-reader"
          # firefox-addons.audibleTabExtension
          firefox-addons.switch-to-audible-tab
          firefox-addons.browserpass
          firefox-addons.refined-github
          # pkgs.nur.repos.rycee.firefox-addons.browserpass-otp

        ]);

      search = {

        force = true;
        engines = {
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
          "NixOS Wiki" = {
            urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
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
            definedAliases = [ "@ho" ];
          };
          "Bing".metaData.hidden = true;
          "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
        };
      };

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
      extensions = [ ];
      # isDefault = false;
      id = 2;
      # path = "6bt2uwrj.nova";
      path = "zwiefm8g.bank";
      settings = { };
    };

    # to use with stable-diffusion
    perso-nogpu = {
      settings = myDefaultSettings // { };
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
      settings = myDefaultSettings // novaSpecificSettings;
      # let { in { };
    };
    # };
  };
}
