with import <nixpkgs> { };

enableDebugging (
  libtermkey.overrideAttrs (oa: {
    name = "libtermkey-matt-${oa.version}";
    # oa.makeFlags
    makeFlags = [ "PREFIX=/home/teto/libtermkey/build" "DEBUG=1" ];
  }))

