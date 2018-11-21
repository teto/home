{ mkDerivation, stack, base, netlink, stdenv
, ghc-mod, hindent, hlint
, optparse-applicative
, hasktags
, Cabal
, Cabal_2_4_0_1
, cabal-install
}:
mkDerivation {
  pname = "netlink-pm";
  version = "1.0.0";
  src = /home/teto/mptcpnetlink/hs;
  isLibrary = false;
  isExecutable = true;
  # libraryHaskellDepends = [ ];
  buildTools = [
    hasktags
    Cabal_2_4_0_1
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
