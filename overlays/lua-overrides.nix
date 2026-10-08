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
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      lrexlib-pcre,
      net-url,
    }:
    buildLuarocksPackage {
      pname = "jsonschema";
      version = "0.9.9-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/jsonschema-0.9.9-0.rockspec";
          sha256 = "1mzlnplcxfv08md0z6hbvsj0bz9ag4q3vlkxxna5g70rxaaja8pc";
        }).outPath;
      src = fetchFromGitHub {
        owner = "iresty";
        repo = "jsonschema";
        tag = "v0.9.9";
        hash = "sha256-BRb65w5q4UL7pCId/gXpN/2ROfczIekFWQ8n2/oP2Qk=";
      };

      propagatedBuildInputs = [
        lrexlib-pcre
        net-url
      ];

      meta = {
        homepage = "https://github.com/iresty/jsonschema";
        license.fullName = "Apache License 2.0";
        description = "JSON Schema data validator";
        longDescription = ''
          This module is  data validator the implements JSON Schema draft 4.
          Given an JSON schema, it will generates a validator function that can be used
          to validate any kind of data (not limited to JSON).

          Base on https://github.com/jdesgats/ljsonschema .
        '';
      };
    }
  ) { };


}
