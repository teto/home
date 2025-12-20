{ pkgs }:
let 
  install_url= "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
in
{
  # copy/pasted from
  # https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons/default.nix?ref_type=heads
  # prev.lib.makeOverridable (
  # buildFirefoxXpiAddon = (
  #   {
  #     stdenv ? pkgs.stdenv,
  #     fetchurl ? pkgs.fetchurl,
  #     pname,
  #     version,
  #     addonId,
  #     url,
  #     sha256,
  #     meta,
  #     ...
  #   }:
  #   stdenv.mkDerivation {
  #     name = "${pname}-${version}";
  #
  #     inherit meta;
  #
  #     src = fetchurl { inherit url sha256; };
  #
  #     preferLocalBuild = true;
  #     allowSubstitutes = true;
  #
  #     passthru = {
  #       inherit addonId;
  #     };
  #
  #     buildCommand = ''
  #       dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
  #       mkdir -p "$dst"
  #       install -v -m644 "$src" "$dst/${addonId}.xpi"
  #     '';
  #   }
  # );

  # check     # https://mozilla.github.io/policy-templates/
  # DisableBuiltinPDFViewer

  commonPolicies = {

    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;


    BlockAboutConfig = false;

    DisableFirefoxStudies = true;
    DisableFirefoxAccounts = false;

    # DisableFirefoxSuggest = true;
    # DisableFormHistory = true;
    DisableTelemetry = true;
    DisplayMenuBar = "default-off";
    DontCheckDefaultBrowser = false;
    DisplayBookmarksToolbar = "always";
    HardwareAcceleration = true;
    DisablePocket = true;

    OfferToSaveLoginsDefault = false;
    PromptForDownloadLocation = true;

    # Homepage = {
    #   # URL = "chrome://browser/content/blanktab.html";
    #   StartPage = "previous-session";
    # };
    # NewTabPage = false;
    NoDefaultBookmarks = true;

    OfferToSaveLogins = false;
    # OverrideFirstRunPage = "";
    PictureInPicture = {
      Enabled = true;
      Locked = true;
    };
    # SearchBar = "unified";
    # ShowHomeButton = false;
    TranslateEnabled = false;

    DefaultDownloadDirectory = "\${home}/Downloads";

    # See https://discourse.nixos.org/t/browser-and-browser-wars/70027/21
    /* ---- EXTENSIONS ---- */
    # Check about:support for extension/add-on ID strings.
    # Valid strings for installation_mode are "allowed", "blocked",
    # "force_installed" and "normal_installed".
    ExtensionSettings = {
        "*" =  {
          "blocked_install_message"= "Custom error message.";
          # "install_sources"= ["https://yourwebsite.com/*"];
          # "installation_mode"= "blocked";
          "allowed_types"= ["extension"];
        };
        # "uBlock0@raymondhill.net": {
        #   "installation_mode": "force_installed",
        #   "install_url": "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
        # },
              # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.policies
      "uBlock0@raymondhill.net" = {
        default_area = "menupanel";
        # install_url = install_url;
        installation_mode = "force_installed";
        private_browsing = true;
      };

      # NihongoTube

      # audible tab
      "{0cd726db-f954-44f2-bf4f-7ed0de734de2}" = {
        default_area = "menupanel";
        installation_mode = "force_installed";
      };

      # 10ten
      "{59812185-ea92-4cca-8ab7-cfcacee81281}" = {
        default_area = "menupanel";
        installation_mode = "force_installed";
      };

      # bonjourr
      "{4f391a9e-8717-4ba6-a5b1-488a34931fcb}" = {
        # default_area = "menupanel";
        installation_mode = "force_installed";

      };
    };
    # ExtensionSettings
  };

  searchEngines = {
    "boardgamegeek" = {
      urls = [
        {
          template = "https://boardgamegeek.org/search/{searchTerms}";
          params = [
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      # icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@bgg" ];
    };

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
    #
    "browser.aboutConfig.showWarning" = "false";
    "browser.download.autohideButton" = "false";
    "browser.newtabpage.activity-stream.topSitesRows" = 3;

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
