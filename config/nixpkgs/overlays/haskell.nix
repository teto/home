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

  haskell = prev.haskell // {

    # to work around a stack bug (stack ghc is hardcoded)
    # compiler = prev.haskell.compiler // { ghc802 = prev.haskell.compiler.ghc844; };

    packageOverrides = hself: hold: with prev.haskell.lib; rec {
      # useful to fetch newer libraries with callHackage
      # gutenhasktags = dontCheck (hprev.callPackage ./pkgs/gutenhasktags {});

          # for newer nixpkgs (March 2020)
          # base-compat = doJailbreak (hold.base-compat);
          # time-compat = doJailbreak (hold.time-compat);

      # ip = dontCheck hprev.ip;
      # c2hsc = dontCheck hprev.c2hsc;

      # should not be needed anymore right ?
      # tensorflow-core-ops = appendPatch (hprev.tensorflow-core-ops) ./pkgs/tensorflow.patch;

      # ihaskell = builtins.trace "overrideCABAL !!" overrideCabal (dontCheck hprev.ihaskell) ( drv: {
      #   executableToolDepends = [ prev.pkgs.jupyter ];
      #   executableHaskellDepends = [ prev.pkgs.jupyter ];
      # });
      # ihaskell = hprev.ihaskell_0_10_0_2;

      # bitset = overrideSrc hprev.bitset { src = prev.fetchFromGitHub {
      #   owner = "teto";
      #   repo = "bitset";
      #   rev = "upgrade";
      #   sha256 = "1bbxav9fxpmpjmd1grwz8wx759kxdmp9lw7rrbd11mx8qj7kwpqx";
      # }; };


      # "fork" by infinisil
      all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
    };
  };

}
