# List of tips https://nixos.org/nix-dev/2015-January/015608.html
# we can find an exaple of an overlay in
# https://github.com/typeable/nixpkgs-stackage/blob/master/default.nix
# https://github.com/NixOS/nixpkgs/issues/44718
self: prev:
{
  # haskell.lib.dontCheck
  # pkgs.haskell.lib.doJailbreak
  # myHaskellOverlay = selfHaskell: prevHaskell: {
  # haskellPackages = prev.haskellPackages.extend myHaskellOverlay;
  # haskell overlay pkgs.haskell.lib.doJailbreak
# pkgs.haskell.lib.doJailbreak
#   jailbreak = true;
# haskellPackages.callCabal2nix to nixpkgs which means anyone can easily pull in GitHub packages and hackage packages that aren't in nixpkgs. 
# pkgs.haskell.lib.dontCheck

  # haskellPkgs = pkgs.haskell.packages.ghc822.override(oldAttrs: {
  #   overrides = self: super: {
  #     nix-miso-template = super.callCabal2nix "nix-miso-template" nix-miso-template-src {};
  #     servant = super.callHackage "servant" "0.12.1" {};
  #     servant-server = super.callHackage "servant-server" "0.12" {};
  #     resourcet = super.callHackage "resourcet" "1.1.11" {};
  #     http-types = super.callHackage "http-types" "0.11" {};
  #   };
  # });

  # all-cabal-hashes = prev.fetchurl {
  #   # https://github.com/commercialhaskell/all-cabal-hashes/tree/hackage
  #   url    = "https://github.com/commercialhaskell/all-cabal-hashes/archive/d174ccaf2ea069c83f1d816bfee7b429c5c70c15.tar.gz";
  #   # sha256 = "0qbzdngm4q8cmwydnrg7jvipw39nb1mjxw95vw6f789874002kn2";
  #   sha256 = "19rgwff6l423xyml6gbhjllznwmrv6x7g46j863i7fgps3ni96sy";
  # };


  haskell = prev.haskell // {
    packageOverrides = hself: hprev: with prev.haskell.lib; rec {  
      # useful to fetch newer libraries with callHackage

      zeromq4-haskell = prev.haskell.lib.dontCheck hprev.zeromq4-haskell;
  #     #       servant = super.callHackage "servant" "0.12.1" {};

      cabal-helper = prev.haskell.lib.doJailbreak (hprev.cabal-helper);

      tensorflow-core-ops = appendPatch (hprev.tensorflow-core-ops) ./pkgs/tensorflow.patch;

      ihaskell = builtins.trace "overrideCABAL !!" overrideCabal (dontCheck hprev.ihaskell) ( drv: {
        executableToolDepends = [ prev.pkgs.jupyter ];
        executableHaskellDepends = [ prev.pkgs.jupyter ];
      });

  #     ghc-syb-utils = hsuper.callHackage "ghc-syb-utils" "0.3.0.0" {};
  #     cabal-plan = hsuper.callHackage "cabal-plan" "0.4.0.0" {};

  #     # cabal-helper = hsuper.callCabal2nix "cabal-helper" (prev.fetchFromGitHub {
  #     #   owner  = "DanielG";
  #     #   repo   = "cabal-helper";
  #     #   rev    = "e2a41086c2b044f4d9c1276a920bba8e3eeb501c";
  #     #   sha256 = "1vgrb2pgm1891n4m2kdl0kp9l52fh2gn6a6z0gb1c9njad52bh4m";
  #     # }) {};

    };
  };

}
