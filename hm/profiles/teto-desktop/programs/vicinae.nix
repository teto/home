{ config, pkgs, ... }:
{
  enable = true;
  systemd.enable = true;

  # https://docs.vicinae.com/nixos
  # ~/.config/vicinae/settings.json.
  # settings =
  # {
  #                  favicon_service = "twenty";
  #                  font.normal.size = 10;
  #                  pop_to_root_on_close=false;
  #                  search_files_in_root= false;
  #                  theme = {
  #                    dark.name = "vicinae-dark";
  #                    light.name = "vicinae-light";
  #                  };
  #                };

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
    [
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
