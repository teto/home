gfinal: gprev: 
# let 
  # generated =  ./luarocks-packages/generated.nix;

# in
  {
    # TODO we should not need this if it's in Repo ?

  # lua5_1 = gprev.lua5_1.override {
  #
  #   packageOverrides = final: prev: let
  #     # testEnv = (luaprev.lua.withPackages (p: [
  #     # ])).overrideAttrs (oa: {
  #     #   NIX_DEBUG = 9;
  #     # });
  #       # final: prev:
  #       # generated = pkgs.callPackage ./luarocks-packages/generated.nix { inherit (final) callPackage; } final prev;
  #   in 
  #     generated;
  #
  # };

  # lua51Packages = lua5_1.pkgs;
  # luaPackages = lua.pkgs;
}
