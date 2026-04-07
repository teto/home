{ config, pkgs, ... }:
{
  enable = true;
  systemd.enable = true;

  # https://docs.vicinae.com/nixos
  # ~/.config/vicinae/settings.json.
  # the website doesn't describe options, one has to checkout:
  # vicinae config default | less
  settings = {
    # To do so, you simply need to add the files to import to the imports array. Files imported in this way are merged before the main user configuration file is considered and are never touched by vicinae directly, allowing them to be freely formatted and annotated with custom comments.
    # Imported files are merged with the default config before the main user configuration file, which means that value present in the user configuration file will always override those that were imported.
    imports = [ "manual.json" ];
    # Supports "navigate_back" or "close_window"
    escape_key_behavior = "navigate_back";
    # Available values are: 'twenty' | 'google' | 'none'
    # If this is set to 'none', favicon loading is disabled and a placeholder icon will be used when a favicon is expected.
    favicon_service = "twenty";
    font.normal.size = 10;
    pop_to_root_on_close = false;
    search_files_in_root = false;
    theme = {
      dark.name = "vicinae-dark";
      light.name = "vicinae-light";
    };
    launcher_window = {
      # Control the opacity of the main window.
      # Opacity for other surfaces are controlled by the active theme.
      opacity = 0.95;

      # // Blur the window background.
      # // Only suported on Hyprland for now.
      # // May require a server restart to disable properly.
      blur = {
        "enabled" = true;
      };

      # // Dims everything behind the vicinae window.
      # // Only supported on Hyprland for now.
      # // May require a server restart to disable properly.
      "dim_around" = true;
    };

    "compact_mode" = {
      "enabled" = false;
    };

    # // The vicinae UI is designed to work best at the default size. If you change this it is highly recommended
    # // that you preserve a similar aspect ratio.
    "size" = {
      # TODO can I use pourcentage ?
      "width" = "0.5";
      "height" = 480;
    };

    # // Keybinds are serialized using a custom format.
    # // It is recommended to edit them through the settings GUI, which will write them to this file.
    # "keybinds": {
    #         // common shortcuts
    #         "open-search-filter": "control+P",

    # // List of entrypoints that are tagged as "favorite".
    # // They show up on the very top of the root search when no search query is active.
    # // Each value is a serialized entrypoint ID.
    # "favorites": [
    #         "clipboard:history"
    # ],
    #
    # // List of entrypoints to suggest as a fallback when no result matches the
    # // provided search query.
    # // Each value is a serialized entrypoint ID.
    # "fallbacks": [
    #         "files:search"
    # ],
  };

  extensions =
    let
      # TODO update extensions example + add imports
      ext_src = pkgs.fetchFromGitHub {
        owner = "vicinaehq";
        repo = "extensions";
        rev = "cf30b80f619282d45b1748eb76e784a4f875bb01";
        sha256 = "sha256-KwNv+THKbNUey10q26NZPDMSzYTObRHaSDr81QP9CPY=";
      };
    in
    # "bluetooth" / "nix" / "wifi-commander" / "ssh"
    # https://www.raycast.com/capipo/pass
    # https://www.raycast.com/afok/password-store
    [
      (config.lib.vicinae.mkRayCastExtension {
        name = "dad-jokes";
        rev = "b8c8fcd7ebd441a5452b396923f2a40e879565ba";
        sha256 = "sha256-07IYIMKQjGlVWSDN1CX8wGOrx3Ob1beZeGmhaEMQYa4=";
      })
      # broken with file-size-format
      # (config.lib.vicinae.mkRayCastExtension {
      #   name = "gif-search";
      #   rev = "4d417c2dfd86a5b2bea202d4a7b48d8eb3dbaeb1";
      #   sha256 = "sha256-G7il8T1L+P/2mXWJsb68n4BCbVKcrrtK8GnBNxzt73Q=";
      # })
      (config.lib.vicinae.mkRayCastExtension {
        name = "github";
        rev = "238052eeb0e2fb9acb1f9418dd7178eafac5e5cf";
        sha256 = "sha256-WjikX+a0h7Z65jhwclpjHLweEuPulG4wptGJiJfMT+0=";
      })
      # (config.lib.vicinae.mkRayCastExtension {
      #   name = "base64";
      #   rev = "9befbb8bad621365a0f2896a13f6fb26fecb8d55";
      #   sha256 = "sha256-T/utRy3ptNlC+v3X9ebnzRuCLVlSkZnm7sRwikIVeAk=";
      # })
      # FIXME: broken build
      # pm error code 1, tries to contact github
      # > npm error path /build/bitwarden/node_modules/electron
      # > npm error command failed
      # > npm error command sh -c node install.js
      # > npm error RequestError: getaddrinfo EAI_AGAIN github.com
      # (config.lib.vicinae.mkRayCastExtension {
      #   name = "bitwarden";
      #   rev = "d7f68ce8eb9759f2c3a9c1bdfe5991b14f55c6f7";
      #   sha256 = "sha256-YcjrBdqeNgC116LKzfPdz1AmupxwvkmwFBbzBDK7wCI=";
      # })
      (config.lib.vicinae.mkExtension {
        name = "bluetooth";
        src =
        "${ext_src}/extensions/bluetooth";
        })

      (config.lib.vicinae.mkExtension {
        name = "pass";
        src =
        "${ext_src}/extensions/pass";
        })
      # (config.lib.vicinae.mkRayCastExtension {
      #
      #   name = "gif-search";
      #   sha256 = "sha256-G7il8T1L+P/2mXWJsb68n4BCbVKcrrtK8GnBNxzt73Q=";
      #   rev = "4d417c2dfd86a5b2bea202d4a7b48d8eb3dbaeb1";
      # })
    ];

}
