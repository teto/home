{
  config,
  pkgs,
  lib,
  ...
}:
let

  ffLib = pkgs.callPackage ../../../../nixpkgs/lib/firefox.nix { };

in
{

  # TODO prefix with stable
  # look at firefox/wrapper to add policies
  # https://github.com/mozilla/policy-templates#enterprisepoliciesenabled
  # programs.firefox = {
  enable = true;

  # this is from my module
  # addMySearchEngines = true;

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
    BlockAboutConfig = false;
    AppAutoUpdate = true;

    # DefaultDownloadDirectory
    # DisableFormHistory;
    DisablePocket = true;
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
      # Not accepted. we should find another way to enable it
      # pass package for instance
      # with pkgs.nur.repos.rycee.firefox-addons;
      # with pkgs;

      # pkgs.open-in-mpv
      extensions = {
        packages =
          ffLib.commonExtensions
          ++ (with pkgs; [
            # TODO no need for bitwarden anymore
            firefox-addons.browserpass
            firefox-addons."10ten-ja-reader"
            # firefox-addons.audibleTabExtension
            firefox-addons.switch-to-audible-tab
            firefox-addons.refined-github
            # pkgs.nur.repos.rycee.firefox-addons.browserpass-otp

          ]);
        # autoDisableScopes = 0;
        # update.autoUpdateDefault = false;
      };

      search = {
        force = true;
        engines = ffLib.searchEngines;
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
        # firefox-addons.browserpass
        # firefox-addons.argent-x # renamed to "ready wallet" ? has disappeared from mozilla store...
        firefox-addons.metamask
      ];
      # isDefault = false;
      id = 10;
      path = "l6ll66o0.bank";
      settings = { };

    };

    # to use with stable-diffusion
    perso-nogpu = {
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
