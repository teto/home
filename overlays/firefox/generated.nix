{
  buildFirefoxXpiAddon,
  fetchurl,
  lib,
  stdenv,
}:
{
  "10ten-ja-reader" = buildFirefoxXpiAddon {
    pname = "10ten-ja-reader";
    version = "1.25.1";
    addonId = "{59812185-ea92-4cca-8ab7-cfcacee81281}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4539398/10ten_ja_reader-1.25.1.xpi";
    sha256 = "808ed4f1b5db774c6b2e3f0d68b6f8bb46293bc94a0d5450f0d877aa60407d63";
    meta = with lib; {
      homepage = "https://10ten.life";
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
    version = "2025.10.0";
    addonId = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4599707/bitwarden_password_manager-2025.10.0.xpi";
    sha256 = "31b88743f36032fa3cfb78e0582fb732ef00a3c5915182ba37fd08b04aac1d3b";
    meta = with lib; {
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
        "notifications"
        "file:///*"
      ];
      platforms = platforms.all;
    };
  };
  "browserpass" = buildFirefoxXpiAddon {
    pname = "browserpass";
    version = "3.11.0";
    addonId = "browserpass@maximbaz.com";
    url = "https://addons.mozilla.org/firefox/downloads/file/4542488/browserpass_ce-3.11.0.xpi";
    sha256 = "11acffd3dbfe0be493c7855669dd24faf325dda8a2ee0ee67148969500f5d778";
    meta = with lib; {
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
    version = "4.9.112";
    addonId = "addon@darkreader.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/4598977/darkreader-4.9.112.xpi";
    sha256 = "dc1fc27b5e61662f1e1e8a60cbf8e11a77443888e40603f88db7c6b9e4ecb437";
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
    version = "3.0.0";
    addonId = "jid1-BoFifL9Vbdl2zQ@jetpack";
    url = "https://addons.mozilla.org/firefox/downloads/file/4392113/decentraleyes-3.0.0.xpi";
    sha256 = "6f2efed90696ac7f8ca7efb8ab308feb3bdf182350b3acfdf4050c09cc02f113";
    meta = with lib; {
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
    version = "5.2.7";
    addonId = "headereditor-amo@addon.firefoxcn.net";
    url = "https://addons.mozilla.org/firefox/downloads/file/4589105/header_editor-5.2.7.xpi";
    sha256 = "7edc8aa17e79dc3271fa3ece87b9c4f1ad1cc2ac68574723d565c764048fbdc1";
    meta = with lib; {
      homepage = "https://he.firefoxcn.net/en/";
      description = "Manage browser's requests, include modify the request headers and response headers, redirect requests, cancel requests";
      license = licenses.gpl2;
      mozPermissions = [
        "tabs"
        "storage"
        "unlimitedStorage"
        "webRequest"
        "webRequestBlocking"
        "declarativeNetRequest"
        "*://*/*"
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
    version = "13.4.0";
    addonId = "webextension@metamask.io";
    url = "https://addons.mozilla.org/firefox/downloads/file/4590988/ether_metamask-13.4.0.xpi";
    sha256 = "1de19bcbf20e2dc1fb156a0978ddbe8e53874c66fda350062881504cc7004477";
    meta = with lib; {
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
        "identity"
        "file://*/*"
        "*://connect.trezor.io/*/popup.html*"
      ];
      platforms = platforms.all;
    };
  };
  "multi-account-containers" = buildFirefoxXpiAddon {
    pname = "multi-account-containers";
    version = "8.3.4";
    addonId = "@testpilot-containers";
    url = "https://addons.mozilla.org/firefox/downloads/file/4607779/multi_account_containers-8.3.4.xpi";
    sha256 = "c7d1018e7856ac6b27b26eccedd85222398398b00ce7344e93cbb1495d8ea632";
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
    version = "25.11.4";
    addonId = "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4612464/refined_github-25.11.4.xpi";
    sha256 = "240ccda8bd39c1e0d2d0eb4113825856cf7f2bdabd6b323ee164f02ca11a7dea";
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
    version = "4.2.7";
    addonId = "treestyletab@piro.sakura.ne.jp";
    url = "https://addons.mozilla.org/firefox/downloads/file/4602712/tree_style_tab-4.2.7.xpi";
    sha256 = "098fa380635788ab25968ce25bd2911b3d03c41f99bcd3d3ca65572d9a37021b";
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
        "tabGroups"
        "tabs"
        "theme"
      ];
      platforms = platforms.all;
    };
  };
  "ublock-origin" = buildFirefoxXpiAddon {
    pname = "ublock-origin";
    version = "1.67.0";
    addonId = "uBlock0@raymondhill.net";
    url = "https://addons.mozilla.org/firefox/downloads/file/4598854/ublock_origin-1.67.0.xpi";
    sha256 = "b83c6ec49f817a8d05d288b53dbc7005cceccf82e9490d8683b3120aab3c133a";
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
