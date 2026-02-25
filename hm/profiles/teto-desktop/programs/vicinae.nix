{ config, ... }:
{
  enable = true;
  systemd.enable = true;

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
  # extensions = [
  #                (config.lib.vicinae.mkExtension {
  #                  name = "test-extension";
  #                  src =
  #                    pkgs.fetchFromGitHub {
  #                      owner = "schromp";
  #                      repo = "vicinae-extensions";
  #                      rev = "f8be5c89393a336f773d679d22faf82d59631991";
  #                      sha256 = "sha256-zk7WIJ19ITzRFnqGSMtX35SgPGq0Z+M+f7hJRbyQugw=";
  #                    }
  #                    + "/test-extension";
  #                })
  #                (config.lib.vicinae.mkRayCastExtension {
  #                  name = "gif-search";
  #                  sha256 = "sha256-G7il8T1L+P/2mXWJsb68n4BCbVKcrrtK8GnBNxzt73Q=";
  #                  rev = "4d417c2dfd86a5b2bea202d4a7b48d8eb3dbaeb1";
  #                })
  #               ];
}
