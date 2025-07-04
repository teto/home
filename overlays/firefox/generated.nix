{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "10ten-ja-reader" = buildFirefoxXpiAddon {
      pname = "10ten-ja-reader";
      version = "1.24.0";
      addonId = "{59812185-ea92-4cca-8ab7-cfcacee81281}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4467030/10ten_ja_reader-1.24.0.xpi";
      sha256 = "5f35c945be8d96753da5cdcf03d0e9b4b759706f2dd30921f391849c2daa8ef4";
      meta = with lib;
      {
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
    "argent-x" = buildFirefoxXpiAddon {
      pname = "argent-x";
      version = "5.25.1";
      addonId = "{51e0c76c-7dbc-41ba-a45d-c579be84301b}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4505313/argent_x-5.25.1.xpi";
      sha256 = "99680a1e5ac0a54334569683ed95d88803a891fcd471d4ac9007f716a5cdb585";
      meta = with lib;
      {
        homepage = "https://www.argent.xyz/argent-x/";
        description = "7 out of 10 Starknet users choose Argent X as their Starknet wallet.";
        license = licenses.gpl3;
        mozPermissions = [
          "alarms"
          "tabs"
          "storage"
          "unlimitedStorage"
          "notifications"
          "webNavigation"
          "http://localhost/*"
          "https://alpha4.starknet.io/*"
          "https://alpha4-2.starknet.io/*"
          "https://alpha-mainnet.starknet.io/*"
          "https://external.integration.starknet.io/*"
          "https://healthcheck.argent.xyz/*"
          "https://cloud.argent-api.com/*"
          "<all_urls>"
        ];
        platforms = platforms.all;
      };
    };
    "bitwarden" = buildFirefoxXpiAddon {
      pname = "bitwarden";
      version = "2025.5.0";
      addonId = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4493940/bitwarden_password_manager-2025.5.0.xpi";
      sha256 = "56e62622b7c322d2c2c4db04ad3eac2e7454bd7eebffebdcf5ca4b728ba09feb";
      meta = with lib;
      {
        homepage = "https://bitwarden.com";
        description = "At home, at work, or on the go, Bitwarden easily secures all your passwords, passkeys, and sensitive information.";
        license = licenses.gpl3;
        mozPermissions = [
          "<all_urls>"
          "*://*/*"
          "alarms"
          "clipboardRead"
          "clipboardWrite"
          "contextMenus"
          "idle"
          "storage"
          "tabs"
          "unlimitedStorage"
          "webNavigation"
          "webRequest"
          "webRequestBlocking"
          "file:///*"
        ];
        platforms = platforms.all;
      };
    };
    "browserpass" = buildFirefoxXpiAddon {
      pname = "browserpass";
      version = "3.10.2";
      addonId = "browserpass@maximbaz.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/4468825/browserpass_ce-3.10.2.xpi";
      sha256 = "63e9e11968ccd019d6ea271addf0ffe17ad78f2d98b8a87e244d609539b2ed0f";
      meta = with lib;
      {
        homepage = "https://github.com/browserpass/browserpass-extension";
        description = "Browserpass is a browser extension for Firefox and Chrome to retrieve login details from zx2c4's pass (passwordstore.org) straight from your browser. Tags: passwordstore, password store, password manager, passwordmanager, gpg";
        license = licenses.isc;
        mozPermissions = [
          "activeTab"
          "alarms"
          "tabs"
          "clipboardRead"
          "clipboardWrite"
          "nativeMessaging"
          "notifications"
          "scripting"
          "storage"
          "webRequest"
          "webRequestAuthProvider"
        ];
        platforms = platforms.all;
      };
    };
    "darkreader" = buildFirefoxXpiAddon {
      pname = "darkreader";
      version = "4.9.106";
      addonId = "addon@darkreader.org";
      url = "https://addons.mozilla.org/firefox/downloads/file/4488139/darkreader-4.9.106.xpi";
      sha256 = "23c94085063aa6b57fae40ca9111ab049fffca5476c29e9990db3aa1a3fe1f10";
      meta = with lib;
      {
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
      version = "3.0.0";
      addonId = "jid1-BoFifL9Vbdl2zQ@jetpack";
      url = "https://addons.mozilla.org/firefox/downloads/file/4392113/decentraleyes-3.0.0.xpi";
      sha256 = "6f2efed90696ac7f8ca7efb8ab308feb3bdf182350b3acfdf4050c09cc02f113";
      meta = with lib;
      {
        homepage = "https://decentraleyes.org";
        description = "Protects you against tracking through \"free\", centralized, content delivery. It prevents a lot of requests from reaching networks like Google Hosted Libraries, and serves local files to keep sites from breaking. Complements regular content blockers.";
        license = licenses.mpl20;
        mozPermissions = [
          "privacy"
          "webNavigation"
          "webRequestBlocking"
          "webRequest"
          "unlimitedStorage"
          "storage"
          "tabs"
        ];
        platforms = platforms.all;
      };
    };
    "facebook-container" = buildFirefoxXpiAddon {
      pname = "facebook-container";
      version = "2.3.12";
      addonId = "@contain-facebook";
      url = "https://addons.mozilla.org/firefox/downloads/file/4451874/facebook_container-2.3.12.xpi";
      sha256 = "3369bd865877860e6d7d38399d5902b300d3d5737acb2d1342ff5beb1d3780c1";
      meta = with lib;
      {
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
      meta = with lib;
      {
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
      meta = with lib;
      {
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
      meta = with lib;
      {
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
    "metamask" = buildFirefoxXpiAddon {
      pname = "metamask";
      version = "12.17.3";
      addonId = "webextension@metamask.io";
      url = "https://addons.mozilla.org/firefox/downloads/file/4494284/ether_metamask-12.17.3.xpi";
      sha256 = "c9ac19197bd9e2811013e0afb69fb6445c28a929f0a3e479921c3a028f100ac4";
      meta = with lib;
      {
        description = "The most secure wallet for crypto, NFTs, and DeFi, trusted by millions of users";
        mozPermissions = [
          "storage"
          "unlimitedStorage"
          "clipboardWrite"
          "http://*/*"
          "https://*/*"
          "ws://*/*"
          "wss://*/*"
          "activeTab"
          "webRequest"
          "webRequestBlocking"
          "*://*.eth/"
          "notifications"
          "file://*/*"
          "*://connect.trezor.io/*/popup.html*"
        ];
        platforms = platforms.all;
      };
    };
    "multi-account-containers" = buildFirefoxXpiAddon {
      pname = "multi-account-containers";
      version = "8.3.0";
      addonId = "@testpilot-containers";
      url = "https://addons.mozilla.org/firefox/downloads/file/4494279/multi_account_containers-8.3.0.xpi";
      sha256 = "cf7888e9c05713256ea457a4250bf6da0e484e49f7e658703ad7232f8c138230";
      meta = with lib;
      {
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
      version = "25.5.18";
      addonId = "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4495758/refined_github-25.5.18.xpi";
      sha256 = "36c23ff732d3cf221f2764c81883311dae5e23ed2ad352a68d52887d594dab91";
      meta = with lib;
      {
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
      meta = with lib;
      {
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
      meta = with lib;
      {
        homepage = "https://github.com/klntsky/switch-to-audible-tab";
        description = "Focus on tab that is currently making sound (Alt+Shift+A).";
        mozPermissions = [ "tabs" "storage" "menus" "activeTab" ];
        platforms = platforms.all;
      };
    };
    "temporary-containers" = buildFirefoxXpiAddon {
      pname = "temporary-containers";
      version = "1.9.2";
      addonId = "{c607c8df-14a7-4f28-894f-29e8722976af}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3723251/temporary_containers-1.9.2.xpi";
      sha256 = "3340a08c29be7c83bd0fea3fc27fde71e4608a4532d932114b439aa690e7edc0";
      meta = with lib;
      {
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
      version = "4.2.0";
      addonId = "treestyletab@piro.sakura.ne.jp";
      url = "https://addons.mozilla.org/firefox/downloads/file/4505103/tree_style_tab-4.2.0.xpi";
      sha256 = "f1d51638eeb1531f0a222c26b2fb96ae2d3565a60bf990b3cd084ff2258c5917";
      meta = with lib;
      {
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
          "tabGroups"
          "tabs"
          "theme"
        ];
        platforms = platforms.all;
      };
    };
    "ublock-origin" = buildFirefoxXpiAddon {
      pname = "ublock-origin";
      version = "1.64.0";
      addonId = "uBlock0@raymondhill.net";
      url = "https://addons.mozilla.org/firefox/downloads/file/4492375/ublock_origin-1.64.0.xpi";
      sha256 = "b9e1c868bd1ac1defcabf2e01776d1a90effba34b07fe6a21350d45f022e0e9f";
      meta = with lib;
      {
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
      meta = with lib;
      {
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
      meta = with lib;
      {
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