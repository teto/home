{ mkDerivation, stack, base, netlink, stdenv
, ghc-mod, hindent, hlint
, optparse-applicative
, hasktags
, haskdogs
, Cabal
# , Cabal_2_4_0_1
, cabal-install
# , codex
}:
mkDerivation {
  pname = "netlink-pm";
  version = "1.0.0";
  src = /home/teto/mptcpnetlink/hs;
  isLibrary = false;
  isExecutable = true;
  # libraryHaskellDepends = [ ];
  buildTools = [
    haskdogs # seems to build on hasktags/ recursively import things
    hasktags
    # codex # doesn't work
    # Cabal_2_4_0_1
    # cabal-install
  ];

  executableHaskellDepends = [ 
    base 
    netlink 
    optparse-applicative
    # ghc-mod
    # stack
  ];

  license = stdenv.lib.licenses.gpl3;
}
