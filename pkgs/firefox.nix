{ wrapFirefox, firefox-unwrapped, fetchFirefoxAddon }:

let
  myFirefox = wrapFirefox firefox-unwrapped {
    extraExtensions = [
      (fetchFirefoxAddon {
        name = "ublock";
        url = "https://addons.mozilla.org/firefox/downloads/file/3679754/ublock_origin-1.31.0-an+fx.xpi";
        sha256 = "1h768ljlh3pi23l27qp961v1hd0nbj2vasgy11bmcrlqp40zgvnr";
      })
      (fetchFirefoxAddon {
        name = "bitwarden";
        url = "https://addons.mozilla.org/firefox/downloads/file/3677817/bitwarden_free_password_manager-1.47.0-an+fx.xpi";
        sha256 = "sha256-hYBXHTQMYNuAjZdHEM4pbEAVXKFeUozK8VgHiO7PmOo=";
      })
      # https://addons.mozilla.org/firefox/downloads/file/3687872/tree_style_tab_-3.6.3-fx.xpi
    ];

    # see about:policies#documentation
    extraPolicies = {
      CaptivePortal = false;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxAccounts = true;
      DisableAppUpdate = true;
      DisplayMenuBar = "default-off";
      # HomepageURL = "";
      # Extensiosn = 
      FirefoxHome = {
        Pocket = false;
        Snippets = false;
      };
      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
      };
    };
    extraPrefs = ''
      // Show more ssl cert infos
      lockPref("security.identityblock.show_extended_validation", true);
    '';
  };
in
myFirefox
