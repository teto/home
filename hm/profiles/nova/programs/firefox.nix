{
  config,
  pkgs,
  lib,
  ...
}:
let
  ffLib = pkgs.callPackage ../../../../nixpkgs/lib/firefox.nix { };
  novaSpecificSettings = {
    # avoid
    "signon.rememberSignons" = false;
  };
in
{
  programs.firefox = {
    profiles = {
      nova = lib.mkForce {
        extensions = ffLib.commonExtensions;
        # isDefault = false;
        id = 1;
        path = "6bt2uwrj.nova";
        settings = ffLib.myDefaultSettings // novaSpecificSettings;
        search = {
          force = true;
          engines = ffLib.searchEngines;
        };

      };
    };
  };

}
