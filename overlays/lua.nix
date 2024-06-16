final: prev: {

  # lua5_1 = prev.lua5_1.override {

  #   packageOverrides = luafinal: luaprev: {
  #     testEnv = (luaprev.lua.withPackages (p: [
  #     ])).overrideAttrs (oa: {
  #       NIX_DEBUG = 9;
  #     });
  #   };
  # };

  # lua51Packages = lua5_1.pkgs;
  # luaPackages = lua.pkgs;
}
