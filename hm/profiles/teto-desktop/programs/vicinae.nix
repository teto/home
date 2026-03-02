{ config, pkgs, ... }:
{
  enable = true;
  systemd.enable = true;

  # https://docs.vicinae.com/nixos
  # ~/.config/vicinae/settings.json.
  settings =
  {
    imports = [ "manual.json" ];

    favicon_service = "twenty";
    font.normal.size = 10;
    pop_to_root_on_close=false;
    search_files_in_root= false;
    theme = {
      dark.name = "vicinae-dark";
      light.name = "vicinae-light";
    };
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
        (config.lib.vicinae.mkRayCastExtension {
          name = "base64";
          rev = "9befbb8bad621365a0f2896a13f6fb26fecb8d55";
          sha256 = "sha256-T/utRy3ptNlC+v3X9ebnzRuCLVlSkZnm7sRwikIVeAk=";
        })
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
      # (config.lib.vicinae.mkExtension {
      #   name = "bluetooth";
      #   src =
      #   "${ext_src}/bluetooth";
      #   })
      # (config.lib.vicinae.mkRayCastExtension {
      #
      #   name = "gif-search";
      #   sha256 = "sha256-G7il8T1L+P/2mXWJsb68n4BCbVKcrrtK8GnBNxzt73Q=";
      #   rev = "4d417c2dfd86a5b2bea202d4a7b48d8eb3dbaeb1";
      # })
    ];

}
