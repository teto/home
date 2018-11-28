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

  haskell = prev.haskell // {

    compiler = prev.haskell.compiler // { ghc802 = prev.haskell.compiler.ghc844; };

    packageOverrides = hself: hprev: with prev.haskell.lib; rec {  
      # useful to fetch newer libraries with callHackage
      # ghc802 = hprev.ghc844;

      zeromq4-haskell = prev.haskell.lib.dontCheck hprev.zeromq4-haskell;
  #     #       servant = super.callHackage "servant" "0.12.1" {};

      cabal-helper = prev.haskell.lib.doJailbreak (hprev.cabal-helper);

      # should not be needed anymore right ?
      tensorflow-core-ops = appendPatch (hprev.tensorflow-core-ops) ./pkgs/tensorflow.patch;

      ihaskell = builtins.trace "overrideCABAL !!" overrideCabal (dontCheck hprev.ihaskell) ( drv: {
        executableToolDepends = [ prev.pkgs.jupyter ];
        executableHaskellDepends = [ prev.pkgs.jupyter ];
      });


      netlink-pm = let 
        orig = hprev.callPackage ./pkgs/netlink-pm-haskell.nix {};
      in
        orig
        # pkgs.haskell.lib.overrideCabal orig (oa: {})
        ;

      # does not seem to work
      # netlink-pm = hprev.callCabal2nix "netlink-pm" /home/teto/mptcpnetlink/hs {};


    };
  };

}
