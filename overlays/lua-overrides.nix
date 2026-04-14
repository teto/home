# this overlay is to be used as
# luajit = tprev.luajit.override {
#   packageOverrides = final: prev: ;
# };
final: prev: {

  alogger = final.callPackage (
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

  jsonschema = final.callPackage (
{ buildLuarocksPackage, fetchFromGitHub, fetchurl, lrexlib-pcre, net-url }:
buildLuarocksPackage {
  pname = "jsonschema";
  version = "0.9.9-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/jsonschema-0.9.9-0.rockspec";
    sha256 = "1mzlnplcxfv08md0z6hbvsj0bz9ag4q3vlkxxna5g70rxaaja8pc";
  }).outPath;
  src = fetchFromGitHub {
    owner = "iresty";
    repo = "jsonschema";
    tag = "v0.9.9";
    hash = "sha256-BRb65w5q4UL7pCId/gXpN/2ROfczIekFWQ8n2/oP2Qk=";
  };

  propagatedBuildInputs = [ lrexlib-pcre net-url ];

  meta = {
    homepage = "https://github.com/iresty/jsonschema";
    license.fullName = "Apache License 2.0";
    description = "JSON Schema data validator";
    longDescription = ''This module is  data validator the implements JSON Schema draft 4.
Given an JSON schema, it will generates a validator function that can be used
to validate any kind of data (not limited to JSON).

Base on https://github.com/jdesgats/ljsonschema .
'';
  };
}
  ){};

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

}
