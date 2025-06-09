{
  pkgs,
  secrets,
  lib,
  ...
}:
let
  ffLib = pkgs.callPackage ../../../../nixpkgs/lib/firefox.nix { };
  novaSpecificSettings = {
    # avoid
    "signon.rememberSignons" = false;
    "browser.startup.homepage" = secrets.nova.gitlab.uri;

  };
in
{
  programs.firefox = {
    profiles = {
      nova = lib.mkForce {
        extensions.packages = ffLib.commonExtensions;
        # isDefault = false;
        id = 1;
        path = "6bt2uwrj.nova";
        settings = ffLib.myDefaultSettings // novaSpecificSettings;
        search = {
          force = true;
          engines = ffLib.searchEngines;
        };
        containersForce = true;
        containers = {
          "staging" = {
            id = 1;
            color = "green";
            icon = "cart";
          };
          "preprod" = {
            id = 2;
            color = "orange";
            icon = "fruit";
          };
          "prod" = {
            id = 3;
            color = "red";
            icon = "fruit";
          };
        };

      };
    };
  };

}
