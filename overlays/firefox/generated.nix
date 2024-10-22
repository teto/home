{
  buildFirefoxXpiAddon,
  fetchurl,
  lib,
  stdenv,
}:
{
  "10ten-ja-reader" = buildFirefoxXpiAddon {
    pname = "10ten-ja-reader";
    version = "1.22.0";
    addonId = "{59812185-ea92-4cca-8ab7-cfcacee81281}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4371439/10ten_ja_reader-1.22.0.xpi";
    sha256 = "d6f3197b7e3383f2723b9376d93e03fe515e5c610f9c0723d9618b10d3cc4bf1";
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
  "argent-x" = buildFirefoxXpiAddon {
    pname = "argent-x";
    version = "5.19.3";
    addonId = "{51e0c76c-7dbc-41ba-a45d-c579be84301b}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4377196/argent_x-5.19.3.xpi";
    sha256 = "d0cb6617221572fe3c983b8222905079a114356fe573a86f58bcb542231ec2d7";
    meta = with lib; {
      homepage = "https://www.argent.xyz/argent-x/";
      description = "7 out of 10 Starknet users choose Argent X as their Starknet wallet. Join 2m+ Argent users now.";
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
    version = "2024.10.1";
    addonId = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4371752/bitwarden_password_manager-2024.10.1.xpi";
    sha256 = "7b7357ddce2756dc536b86b5c14139ec09731c1c114ac82807c60fba3ced12a5";
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
    version = "4.9.96";
    addonId = "addon@darkreader.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/4378073/darkreader-4.9.96.xpi";
    sha256 = "6e2f1a36d2398195b0cd7ee0fcb198ea4db6a57a1b3bf7b2cf5f17a8768f477e";
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
  "metamask" = buildFirefoxXpiAddon {
    pname = "metamask";
    version = "12.0.6";
    addonId = "webextension@metamask.io";
    url = "https://addons.mozilla.org/firefox/downloads/file/4342782/ether_metamask-12.0.6.xpi";
    sha256 = "a66e20bbe5ded1b9408420e4c2ffc82369cc3bfd27350afe25f2c0ef6b26ff3b";
    meta = with lib; {
      description = "Ethereum Browser Extension";
      mozPermissions = [
        "storage"
        "unlimitedStorage"
        "clipboardWrite"
        "http://localhost:8545/"
        "https://*.infura.io/"
        "https://*.codefi.network/"
        "https://*.cx.metamask.io/"
        "https://chainid.network/chains.json"
        "https://lattice.gridplus.io/*"
        "activeTab"
        "webRequest"
        "*://*.eth/"
        "notifications"
        "file://*/*"
        "http://*/*"
        "https://*/*"
        "*://connect.trezor.io/*/popup.html"
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
    version = "24.11.12";
    addonId = "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4386666/refined_github-24.11.12.xpi";
    sha256 = "883ba8755883af1159027f555e568969fd9507b233a0545035a2a9d990e4cbff";
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
    version = "4.0.24";
    addonId = "treestyletab@piro.sakura.ne.jp";
    url = "https://addons.mozilla.org/firefox/downloads/file/4377780/tree_style_tab-4.0.24.xpi";
    sha256 = "e1826e2054aede2f390cb98ff22915cc1e89778a6ebf94d68467200aeba8fefd";
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
    version = "1.61.0";
    addonId = "uBlock0@raymondhill.net";
    url = "https://addons.mozilla.org/firefox/downloads/file/4382536/ublock_origin-1.61.0.xpi";
    sha256 = "e6fd55b799a568c66c10892a8f22428e6773fe16d7466ce9dee2952f224b203d";
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
