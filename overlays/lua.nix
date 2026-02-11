# tOP prev
tfinal: tprev:
# let
# generated =  ./luarocks-packages/generated.nix;

# in
{
  # TODO we should not need this if it's in Repo ?
  luajit = tprev.luajit.override {
    packageOverrides = final: prev: {

      alogger = final.luaPackages.callPackage (
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

    mega-logging = final.callPackage (
      {
        buildLuarocksPackage,
        fetchurl,
        fetchzip,
      }:
      buildLuarocksPackage {
        pname = "mega.logging";
        version = "1.1.6-1";
        knownRockspec =
          (fetchurl {
            url = "mirror://luarocks/mega.logging-1.1.6-1.rockspec";
            sha256 = "1va6vl4iqnc3ip2ws1ff65xavw1m6wgdrsal1gvqnjn0gh20vxbg";
          }).outPath;
        src = fetchzip {
          url = "https://github.com/ColinKennedy/mega.logging/archive/v1.1.6.zip";
          sha256 = "0sy7f42rbdanz9bi0kq6vzllykqcrp04bp7b5k3cqpml5ckywpl5";
        };

        meta = {
          homepage = "https://github.com/ColinKennedy/mega.logging";
          description = "A Neovim plugin for logging to Neovim or to disk";
          license.fullName = "MIT";
        };
      }
    ) { };

    mega-cmdparse = final.callPackage (
      {
        buildLuarocksPackage,
        fetchurl,
        fetchzip,
        mega-logging,
      }:
      buildLuarocksPackage {
        pname = "mega.cmdparse";
        version = "1.2.1-1";
        knownRockspec =
          (fetchurl {
            url = "mirror://luarocks/mega.cmdparse-1.2.1-1.rockspec";
            sha256 = "1766pqazkr3zfwaaj541m53y90n5zr0r7068hd67d9hgvd7za6sb";
          }).outPath;
        src = fetchzip {
          url = "https://github.com/ColinKennedy/mega.cmdparse/archive/v1.2.1.zip";
          sha256 = "1bf3rf80m65jc51dlv3vcs2jhzk5ni2kr7v5rsmb31k7wk3002qb";
        };

        propagatedBuildInputs = [ mega-logging ];

        meta = {
          homepage = "https://github.com/ColinKennedy/mega.cmdparse";
          description = "A Neovim command-mode parser. Similar to Python's argparse module";
          license.fullName = "MIT";
        };
      }
    ) { };

    # alogger = final.callPackage (
    #   {
    #     buildLuarocksPackage,
    #     fetchFromGitLab,
    #     fetchurl,
    #     luaOlder,
    #   }:
    #   buildLuarocksPackage {
    #     pname = "alogger";
    #     version = "0.6.0-1";
    #     knownRockspec =
    #       (fetchurl {
    #         url = "mirror://luarocks/alogger-0.6.0-1.rockspec";
    #         sha256 = "02hwrx2pxj1vbrv3hsd7bri6hyvajkfs4wvfb70z36h4awn3y2w7";
    #       }).outPath;
    #     src = fetchFromGitLab {
    #       owner = "lua_rocks";
    #       repo = "alogger";
    #       rev = "v0.6.0";
    #       hash = "sha256-/OVwQvm+ViK0rpIbQOzKWYAeLSLBHEPLqlz+r+LmCbA=";
    #     };
    #
    #     disabled = luaOlder "5.1";
    #
    #     meta = {
    #       homepage = "https://gitlab.com/lua_rocks/alogger";
    #       description = "simple logger";
    #       license.fullName = "MIT";
    #     };
    #   }
    # ) { };

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
