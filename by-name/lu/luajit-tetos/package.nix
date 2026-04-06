{ luajit }:
luajit.override {
    packageOverrides = import ../../../overlays/lua-overrides.nix
      # pkgs = final;
      # lib = final.lib;
    ;
  }

