# New profile system is a cluster fuck
# https://github.com/nix-community/home-manager/issues/6934
# https://dredyson.com/firefox-multiple-profiles-management-i-tested-every-solution-including-legacy-vs-new-selectable-profiles-aboutprofiles-command-line-and-third-party-workarounds-heres-what-actually-wor/
{
  config,
  pkgs,
  flakeSelf,
  lib,
  ...
}:
let
  ffLib = lib.firefox;

  nixFlakeIcon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";

  searchEngines = {
    Kotoba = {
      urls = [
        {
          template = "https://kotoba.fr/{searchTerms}";
        }
      ];
      definedAliases = [ "ko" ];
    };

    boardgamegeek = {
      urls = [
        {
          template = "https://boardgamegeek.com/search/{searchTerms}";
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

    Jisho = {
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

    youtube = {
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
      icon = "https://www.youtube.com/s/desktop/18bfd1c0/img/favicon_144x144.png";
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
    "Nixpkgs manual" = {
      urls = [
        { template = "https://nixos.org/manual/nixpkgs/stable?search={searchTerms}"; }
      ];
      # icon = "https://nixos.wiki/favicon.png";
      icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      updateInterval = 24 * 60 * 60 * 1000; # every day
      definedAliases = [ "@nm" ];
    };
    "NixOS Wiki" = {
      urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
      # doesnt work
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

    # todo add https://github.com/NixOS/nixpkgs/pulls?q=sort%3Aupdated-desc+is%3Apr+is%3Aopen+avahi
    github-nixpkgs-pr = {
      urls = [
        {
          template = "https://github.com/NixOS/nixpkgs/pulls?q=sort%3Aupdated-desc+is%3Apr+is%3Aopen+{searchTerms}";
          params = [
            {
              name = "q";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = nixFlakeIcon;
      definedAliases = [
        "@pr-nixpkgs"
      ];
    };

    github = {
      urls = [
        {
          template = "https://github.com/{searchTerms}";
          params = [
            {
              name = "q";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      definedAliases = [
        "@gh"
      ];
    };

    # TODO add nyaa
    # https://nyaa.si/?f=0&c=0_0&q=toto
    toshokan = {
      urls = [
        {
          template = "https://www.tokyotosho.info/search.php?terms={searchTerms}&type=1&searchName=true&searchComment=true&size_min=&size_max=&username=";
          # template = "https://github.com/NixOS/nixpkgs/pulls?q=sort%3Aupdated-desc+is%3Apr+is%3Aopen+{searchTerms}";
          params = [
            {
              name = "q";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      definedAliases = [
        "@tosho"
      ];
    };

    LuaRocks = {
      urls = [
        {
          template = "https://luarocks.org/search?q={searchTerms}";
          params = [
            {
              name = "q";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      definedAliases = [ "@lr" ];
    };

    bing.metaData.hidden = true;
    google.metaData.alias = "@g"; # builtin engines only support specifying one additional alias
  };

  
in
{
  # _imports = [
  #   flakeSelf.homeModules.firefox
  # ];

  # TODO prefix with stable
  # look at firefox/wrapper to add policies
  # https://github.com/mozilla/policy-templates#enterprisepoliciesenabled
  enable = true;

  # from tetos module
  mutableProfilesIni = true;

  configPath = "${config.xdg.configHome}/mozilla/firefox";

  # import the one in pkgs/
  # package = myFirefox;
  languagePacks = [
    "fr-FR"
    "jp-JP"
    "en-GB"
    # 5840
  ];

  # check about:policies
  policies = ffLib.commonPolicies // {
    AppAutoUpdate = true;

    # DefaultDownloadDirectory
    # DisableFormHistory;
    # buggy see https://github.com/nix-community/home-manager/issues/5821
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

  # nativeMessagingHosts = [
  #   # add it to firefox-addons. ?
  #   pkgs.ff2mpv
  # ];

  # Having "profiles.ini" makes firefox -ProfileManager crash with
  # 'An unexpected error has prevented your changes from being saved.'
  # firefox -P or --profile should work though
  profiles = {
    perso = {
      # https://gitlab.com/rycee/configurations/-/blob/bf46aef74ca53a61fe2d35349fe3dbc6a70b2609/user/firefox.nix#L25-39
      settings = ffLib.myDefaultSettings;
      path = "q1pprbmm.default";
      # extraConfig =
      id = 0;

      userChrome =
             ''
               /* Hide tab bar in FF Quantum */
               @-moz-document url(chrome://browser/content/browser.xul), url(chrome://browser/content/browser.xhtml) {
                 #TabsToolbar {
                   visibility: collapse !important;
                   margin-bottom: 21px !important;
                 }

               }
             '';

      # userContent = 
      #        ''
      #          /* Hide scrollbar in FF Quantum */
      #          *{scrollbar-width:none !important}
      #        '';
      #

      # stolen from toolkit.profiles.storeID
      storeId = "e41de5fe";
      # Not accepted. we should find another way to enable it
      # pass package for instance
      # with pkgs.nur.repos.rycee.firefox-addons;
      # pkgs.open-in-mpv

      # TODO install via policy instead
      # extensions = {
      #   packages =
      #     ffLib.commonExtensions
      #     ++ (with pkgs; [
      #       # TODO no need for bitwarden anymore
      #       firefox-addons.browserpass
      #       firefox-addons."10ten-ja-reader"
      #       # firefox-addons.audibleTabExtension
      #       firefox-addons.switch-to-audible-tab
      #       firefox-addons.refined-github
      #       # pkgs.nur.repos.rycee.firefox-addons.browserpass-otp
      #
      #     ]);
      #   # autoDisableScopes = 0;
      #   # update.autoUpdateDefault = false;
      # };

      search = {
        force = true;
        engines = searchEngines;
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
      extensions.packages = [ ];
      # isDefault = false;
      id = 2;
      # path = "6bt2uwrj.nova";
      path = "zwiefm8g.bank";
      settings = { };
    };

    # for dangerous stuff
    sketchy = lib.mkForce {
      extensions.packages = with pkgs; [
        # firefox-addons.argent-x # renamed to "ready wallet" ? has disappeared from mozilla store...
        # firefox-addons.metamask
      ];
      # isDefault = false;
      id = 10;
      path = "l6ll66o0.bank";
      settings = { };

    };

    # to use with stable-diffusion
    jobsearch = {
      settings = ffLib.myDefaultSettings // { };
      id = 5;
    };

    spam = lib.mkForce {
      # isDefault = false;
      id = 4;
      # path = "6bt2uwrj.nova";
      settings = { };
    };

    # };
  };
}
