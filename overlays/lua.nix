final: prev:
# let
# generated =  ./luarocks-packages/generated.nix;

# in
{
  # TODO we should not need this if it's in Repo ?
  luajit = prev.luajit.override {
    packageOverrides = luafinal: luaprev: {

      alogger = luafinal.luaPackages.callPackage (
        {
          buildLuarocksPackage,
          fetchFromGitLab,
          fetchurl,
          luaOlder,
        }:
        buildLuarocksPackage {
          pname = "alogger";
          version = "0.6.0-1";
          knownRockspec =
            (fetchurl {
              url = "mirror://luarocks/alogger-0.6.0-1.rockspec";
              sha256 = "02hwrx2pxj1vbrv3hsd7bri6hyvajkfs4wvfb70z36h4awn3y2w7";
            }).outPath;
          src = fetchFromGitLab {
            owner = "lua_rocks";
            repo = "alogger";
            rev = "v0.6.0";
            hash = "sha256-/OVwQvm+ViK0rpIbQOzKWYAeLSLBHEPLqlz+r+LmCbA=";
          };

          disabled = luaOlder "5.1";

          meta = {
            homepage = "https://gitlab.com/lua_rocks/alogger";
            description = "simple logger";
            license.fullName = "MIT";
          };
        }
      ) { };
    };
  };

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
