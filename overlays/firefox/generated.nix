{
  buildFirefoxXpiAddon,
  fetchurl,
  lib,
  stdenv,
}:
{
  "10ten-ja-reader" = buildFirefoxXpiAddon {
    pname = "10ten-ja-reader";
    version = "1.21.1";
    addonId = "{59812185-ea92-4cca-8ab7-cfcacee81281}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4355635/10ten_ja_reader-1.21.1.xpi";
    sha256 = "81d85cfdc03cb0c921cac84547e7a7a539af11ff9a81dd901b3f3bfa67ba45f1";
    meta = with lib; {
      homepage = "https://github.com/birchill/10ten-ja-reader/";
      description = "Quickly translate Japanese by hovering over words. Formerly released as Rikaichamp.";
      license = licenses.gpl3;
      mozPermissions = [
        "alarms"
        "clipboardWrite"
        "contextMenus"
        "storage"
        "unlimitedStorage"
        "http://*/*"
        "https://*/*"
        "file:///*"
        "https://docs.google.com/*"
      ];
      platforms = platforms.all;
    };
  };
  "bitwarden" = buildFirefoxXpiAddon {
    pname = "bitwarden";
    version = "2024.9.1";
    addonId = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4355865/bitwarden_password_manager-2024.9.1.xpi";
    sha256 = "f484fbcd1e45e4a68f2eec8fb8c22fed5a77f1a00b515f38c167e36b4d6118bf";
    meta = with lib; {
      homepage = "https://bitwarden.com";
      description = "At home, at work, or on the go, Bitwarden easily secures all your passwords, passkeys, and sensitive information.";
      license = licenses.gpl3;
      mozPermissions = [
        "<all_urls>"
        "*://*/*"
        "tabs"
        "contextMenus"
        "storage"
        "unlimitedStorage"
        "clipboardRead"
        "clipboardWrite"
        "idle"
        "alarms"
        "webRequest"
        "webRequestBlocking"
        "webNavigation"
        "file:///*"
        "https://lastpass.com/export.php"
      ];
      platforms = platforms.all;
    };
  };
  "browserpass" = buildFirefoxXpiAddon {
    pname = "browserpass";
    version = "3.8.0";
    addonId = "browserpass@maximbaz.com";
    url = "https://addons.mozilla.org/firefox/downloads/file/4187654/browserpass_ce-3.8.0.xpi";
    sha256 = "5291d94443be41a80919605b0939c16cc62f9100a8b27df713b735856140a9a7";
    meta = with lib; {
      homepage = "https://github.com/browserpass/browserpass-extension";
      description = "Browserpass is a browser extension for Firefox and Chrome to retrieve login details from zx2c4's pass (<a href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/fcd8dcb23434c51a78197a1c25d3e2277aa1bc764c827b4b4726ec5a5657eb64/http%3A//passwordstore.org\" rel=\"nofollow\">passwordstore.org</a>) straight from your browser. Tags: passwordstore, password store, password manager, passwordmanager, gpg";
      license = licenses.isc;
      mozPermissions = [
        "activeTab"
        "alarms"
        "tabs"
        "clipboardRead"
        "clipboardWrite"
        "nativeMessaging"
        "notifications"
        "webRequest"
        "webRequestBlocking"
        "http://*/*"
        "https://*/*"
      ];
      platforms = platforms.all;
    };
  };
  "darkreader" = buildFirefoxXpiAddon {
    pname = "darkreader";
    version = "4.9.94";
    addonId = "addon@darkreader.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/4359254/darkreader-4.9.94.xpi";
    sha256 = "251c4e7d0a30c0cab006803600e59ab92dcc0c606429740d42677846d4c9ccd6";
    meta = with lib; {
      homepage = "https://darkreader.org/";
      description = "Dark mode for every website. Take care of your eyes, use dark theme for night and daily browsing.";
      license = licenses.mit;
      mozPermissions = [
        "alarms"
        "contextMenus"
        "storage"
        "tabs"
        "theme"
        "<all_urls>"
      ];
      platforms = platforms.all;
    };
  };
  "decentraleyes" = buildFirefoxXpiAddon {
    pname = "decentraleyes";
    version = "2.0.19";
    addonId = "jid1-BoFifL9Vbdl2zQ@jetpack";
    url = "https://addons.mozilla.org/firefox/downloads/file/4255788/decentraleyes-2.0.19.xpi";
    sha256 = "105d65bf8189d527251647d0452715c5725af6065fba67cd08187190aae4a98f";
    meta = with lib; {
      homepage = "https://decentraleyes.org";
      description = "Protects you against tracking through \"free\", centralized, content delivery. It prevents a lot of requests from reaching networks like Google Hosted Libraries, and serves local files to keep sites from breaking. Complements regular content blockers.";
      license = licenses.mpl20;
      mozPermissions = [
        "*://*/*"
        "privacy"
        "storage"
        "unlimitedStorage"
        "tabs"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
      ];
      platforms = platforms.all;
    };
  };
  "facebook-container" = buildFirefoxXpiAddon {
    pname = "facebook-container";
    version = "2.3.11";
    addonId = "@contain-facebook";
    url = "https://addons.mozilla.org/firefox/downloads/file/4141092/facebook_container-2.3.11.xpi";
    sha256 = "90dd562ffe0e6637791456558eabe083b0253e2b8a5df28f0ed0fdf1b7b175d0";
    meta = with lib; {
      homepage = "https://github.com/mozilla/contain-facebook";
      description = "Prevent Facebook from tracking you around the web. The Facebook Container extension for Firefox helps you take control and isolate your web activity from Facebook.";
      license = licenses.mpl20;
      mozPermissions = [
        "<all_urls>"
        "browsingData"
        "contextualIdentities"
        "cookies"
        "management"
        "storage"
        "tabs"
        "webRequestBlocking"
        "webRequest"
      ];
      platforms = platforms.all;
    };
  };
  "firefox-color" = buildFirefoxXpiAddon {
    pname = "firefox-color";
    version = "2.1.7";
    addonId = "FirefoxColor@mozilla.com";
    url = "https://addons.mozilla.org/firefox/downloads/file/3643624/firefox_color-2.1.7.xpi";
    sha256 = "b7fb07b6788f7233dd6223e780e189b4c7b956c25c40493c28d7020493249292";
    meta = with lib; {
      homepage = "https://color.firefox.com";
      description = "Build, save and share beautiful Firefox themes.";
      license = licenses.mpl20;
      mozPermissions = [
        "theme"
        "storage"
        "tabs"
        "https://color.firefox.com/*"
      ];
      platforms = platforms.all;
    };
  };
  "header-editor" = buildFirefoxXpiAddon {
    pname = "header-editor";
    version = "4.1.1";
    addonId = "headereditor-amo@addon.firefoxcn.net";
    url = "https://addons.mozilla.org/firefox/downloads/file/3472456/header_editor-4.1.1.xpi";
    sha256 = "389fba1a1a08b97f8b4bf0ed9c21ac2e966093ec43cecb80fc574997a0a99766";
    meta = with lib; {
      homepage = "https://he.firefoxcn.net/en/";
      description = "Manage browser's requests, include modify the request headers and response headers, redirect requests, cancel requests";
      license = licenses.gpl2;
      mozPermissions = [
        "tabs"
        "webRequest"
        "webRequestBlocking"
        "contextMenus"
        "storage"
        "downloads"
        "*://*/*"
        "unlimitedStorage"
      ];
      platforms = platforms.all;
    };
  };
  "i-dont-care-about-cookies" = buildFirefoxXpiAddon {
    pname = "i-dont-care-about-cookies";
    version = "3.5.0";
    addonId = "jid1-KKzOGWgsW3Ao4Q@jetpack";
    url = "https://addons.mozilla.org/firefox/downloads/file/4202634/i_dont_care_about_cookies-3.5.0.xpi";
    sha256 = "4de284454217fc4bee0744fb0aad8e0e10fa540dc03251013afc3ee4c20e49b0";
    meta = with lib; {
      homepage = "https://www.i-dont-care-about-cookies.eu/";
      description = "Get rid of cookie warnings from almost all websites!";
      license = licenses.gpl3;
      mozPermissions = [
        "tabs"
        "storage"
        "http://*/*"
        "https://*/*"
        "notifications"
        "webRequest"
        "webRequestBlocking"
        "webNavigation"
      ];
      platforms = platforms.all;
    };
  };
  "multi-account-containers" = buildFirefoxXpiAddon {
    pname = "multi-account-containers";
    version = "8.2.0";
    addonId = "@testpilot-containers";
    url = "https://addons.mozilla.org/firefox/downloads/file/4355970/multi_account_containers-8.2.0.xpi";
    sha256 = "1ce35650853973572bc1ce770076d93e00b6b723b799f7b90c3045268c64b422";
    meta = with lib; {
      homepage = "https://github.com/mozilla/multi-account-containers/#readme";
      description = "Firefox Multi-Account Containers lets you keep parts of your online life separated into color-coded tabs. Cookies are separated by container, allowing you to use the web with multiple accounts and integrate Mozilla VPN for an extra layer of privacy.";
      license = licenses.mpl20;
      mozPermissions = [
        "<all_urls>"
        "activeTab"
        "cookies"
        "contextMenus"
        "contextualIdentities"
        "history"
        "idle"
        "management"
        "storage"
        "unlimitedStorage"
        "tabs"
        "webRequestBlocking"
        "webRequest"
      ];
      platforms = platforms.all;
    };
  };
  "refined-github" = buildFirefoxXpiAddon {
    pname = "refined-github";
    version = "24.10.1";
    addonId = "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4362555/refined_github-24.10.1.xpi";
    sha256 = "d922b9094365977860ec490d66fa96b004bb8446084930111514b2d8a6143c1d";
    meta = with lib; {
      homepage = "https://github.com/refined-github/refined-github";
      description = "Simplifies the GitHub interface and adds many useful features.";
      license = licenses.mit;
      mozPermissions = [
        "storage"
        "scripting"
        "contextMenus"
        "activeTab"
        "alarms"
        "https://github.com/*"
        "https://api.github.com/*"
        "https://gist.github.com/*"
      ];
      platforms = platforms.all;
    };
  };
  "save-page-we" = buildFirefoxXpiAddon {
    pname = "save-page-we";
    version = "28.11";
    addonId = "savepage-we@DW-dev";
    url = "https://addons.mozilla.org/firefox/downloads/file/4091842/save_page_we-28.11.xpi";
    sha256 = "26f9504711fa44014f8cb57053d0900153b446e62308ccf1f3d989c287771cfd";
    meta = with lib; {
      description = "Save a complete web page (as currently displayed) as a single HTML file that can be opened in any browser. Save a single page, multiple selected pages or a list of page URLs. Automate saving from command line.";
      license = licenses.gpl2;
      mozPermissions = [
        "http://*/*"
        "https://*/*"
        "file:///*"
        "tabs"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
        "downloads"
        "contextMenus"
        "notifications"
        "storage"
      ];
      platforms = platforms.all;
    };
  };
  "switch-to-audible-tab" = buildFirefoxXpiAddon {
    pname = "switch-to-audible-tab";
    version = "0.0.9";
    addonId = "{0cd726db-f954-44f2-bf4f-7ed0de734de2}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3870392/switch_to_audible_tab-0.0.9.xpi";
    sha256 = "a86a38e03e8821d9734587f3516109491f51d1373079cb68760a8e9db333dd48";
    meta = with lib; {
      homepage = "https://github.com/klntsky/switch-to-audible-tab";
      description = "Focus on tab that is currently making sound (Alt+Shift+A).";
      mozPermissions = [
        "tabs"
        "storage"
        "menus"
        "activeTab"
      ];
      platforms = platforms.all;
    };
  };
  "temporary-containers" = buildFirefoxXpiAddon {
    pname = "temporary-containers";
    version = "1.9.2";
    addonId = "{c607c8df-14a7-4f28-894f-29e8722976af}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3723251/temporary_containers-1.9.2.xpi";
    sha256 = "3340a08c29be7c83bd0fea3fc27fde71e4608a4532d932114b439aa690e7edc0";
    meta = with lib; {
      homepage = "https://github.com/stoically/temporary-containers";
      description = "Open tabs, websites, and links in automatically managed disposable containers which isolate the data websites store (cookies, storage, and more) from each other, enhancing your privacy and security while you browse.";
      license = licenses.mit;
      mozPermissions = [
        "<all_urls>"
        "contextMenus"
        "contextualIdentities"
        "cookies"
        "management"
        "storage"
        "tabs"
        "webRequest"
        "webRequestBlocking"
      ];
      platforms = platforms.all;
    };
  };
  "tree-style-tab" = buildFirefoxXpiAddon {
    pname = "tree-style-tab";
    version = "4.0.23";
    addonId = "treestyletab@piro.sakura.ne.jp";
    url = "https://addons.mozilla.org/firefox/downloads/file/4350896/tree_style_tab-4.0.23.xpi";
    sha256 = "d8061eff00b56ccfdd6fd290b14ef2c8ef692a14eb8db1a27529f21e43df1f30";
    meta = with lib; {
      homepage = "http://piro.sakura.ne.jp/xul/_treestyletab.html.en";
      description = "Show tabs like a tree.";
      mozPermissions = [
        "activeTab"
        "contextualIdentities"
        "cookies"
        "menus"
        "menus.overrideContext"
        "notifications"
        "search"
        "sessions"
        "storage"
        "tabs"
        "theme"
      ];
      platforms = platforms.all;
    };
  };
  "ublock-origin" = buildFirefoxXpiAddon {
    pname = "ublock-origin";
    version = "1.60.0";
    addonId = "uBlock0@raymondhill.net";
    url = "https://addons.mozilla.org/firefox/downloads/file/4359936/ublock_origin-1.60.0.xpi";
    sha256 = "e2cda9b2a1b0a7f6e5ef0da9f87f28df52f8560587ba2e51a3003121cfb81600";
    meta = with lib; {
      homepage = "https://github.com/gorhill/uBlock#ublock-origin";
      description = "Finally, an efficient wide-spectrum content blocker. Easy on CPU and memory.";
      license = licenses.gpl3;
      mozPermissions = [
        "alarms"
        "dns"
        "menus"
        "privacy"
        "storage"
        "tabs"
        "unlimitedStorage"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
        "<all_urls>"
        "http://*/*"
        "https://*/*"
        "file://*/*"
        "https://easylist.to/*"
        "https://*.fanboy.co.nz/*"
        "https://filterlists.com/*"
        "https://forums.lanik.us/*"
        "https://github.com/*"
        "https://*.github.io/*"
        "https://github.com/uBlockOrigin/*"
        "https://ublockorigin.github.io/*"
        "https://*.reddit.com/r/uBlockOrigin/*"
      ];
      platforms = platforms.all;
    };
  };
  "umatrix" = buildFirefoxXpiAddon {
    pname = "umatrix";
    version = "1.4.4";
    addonId = "uMatrix@raymondhill.net";
    url = "https://addons.mozilla.org/firefox/downloads/file/3812704/umatrix-1.4.4.xpi";
    sha256 = "1de172b1d82de28c334834f7b0eaece0b503f59e62cfc0ccf23222b8f2cb88e5";
    meta = with lib; {
      homepage = "https://github.com/gorhill/uMatrix";
      description = "Point &amp; click to forbid/allow any class of requests made by your browser. Use it to block scripts, iframes, ads, facebook, etc.";
      license = licenses.gpl3;
      mozPermissions = [
        "browsingData"
        "cookies"
        "privacy"
        "storage"
        "tabs"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
        "<all_urls>"
        "http://*/*"
        "https://*/*"
      ];
      platforms = platforms.all;
    };
  };
  "vim-vixen" = buildFirefoxXpiAddon {
    pname = "vim-vixen";
    version = "1.2.3";
    addonId = "vim-vixen@i-beam.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/3845233/vim_vixen-1.2.3.xpi";
    sha256 = "8f86c77ac8e65dfd3f1a32690b56ce9231ac7686d5a86bf85e3d5cc5a3a9e9b5";
    meta = with lib; {
      homepage = "https://github.com/ueokande/vim-vixen";
      description = "Accelerates your web browsing with Vim power!!";
      license = licenses.mit;
      mozPermissions = [
        "history"
        "sessions"
        "storage"
        "tabs"
        "clipboardRead"
        "notifications"
        "bookmarks"
        "browserSettings"
        "<all_urls>"
      ];
      platforms = platforms.all;
    };
  };
}
