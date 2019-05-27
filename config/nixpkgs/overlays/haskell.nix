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
  yst = prev.haskellPackages.yst.overrideAttrs (oldAttrs: {
     jailbreak = true;
  });


  haskell = prev.haskell // {

    # to work around a stack bug (stack ghc is hardcoded)
    # compiler = prev.haskell.compiler // { ghc802 = prev.haskell.compiler.ghc844; };

    packageOverrides = hself: hprev: with prev.haskell.lib; rec {
      # useful to fetch newer libraries with callHackage
      # ghc802 = hprev.ghc844;
      gutenhasktags = dontCheck (hprev.callPackage ./pkgs/gutenhasktags {});

      ip = dontCheck hprev.ip;

      zeromq4-haskell = prev.haskell.lib.dontCheck hprev.zeromq4-haskell;

      # cabal-helper = prev.haskell.lib.doJailbreak (hprev.cabal-helper);

      # should not be needed anymore right ?
      tensorflow-core-ops = appendPatch (hprev.tensorflow-core-ops) ./pkgs/tensorflow.patch;

      ihaskell = builtins.trace "overrideCABAL !!" overrideCabal (dontCheck hprev.ihaskell) ( drv: {
        executableToolDepends = [ prev.pkgs.jupyter ];
        executableHaskellDepends = [ prev.pkgs.jupyter ];
      });

      # TODO enable profiling ?
      # or "logger"
      # http://hackage.haskell.org/package/logger
      # "netlink" = prev.haskell.lib.addBuildDepends  (prev.haskell.lib.overrideSrc hprev.netlink {

      #   # src = builtins.fetchGit {
      #   #   # url = https://github.com/ongy/netlink-hs;
      #   #   url = https://github.com/teto/netlink-hs;
      #   # };

      #   src = /home/teto/netlink-hs;

      #   # src = prev.fetchFromGitHub {
      #   #   owner = "ongy";
      #   #   repo = "netlink-hs";
      #   #   rev = "8e7a285f7e4cee0a7f908e431559c87c2f228783";
      #   #   sha256 = "05hq41zh5msm06gfgfjvf1lq1qnqg1l2ng1ywiikkck8msc3mmx1";
      #   # };
      # }) [
      #   hprev.fast-logger
      #   # hprev.hsc2hs
      #   # (doJailbreak hprev.logger)
      # ];

      # test = hprev.ghcWithPackages(hs: [ hs.fast-logger ]).override({ makeWrapperArgs = [
      #   ''--set TOTO "hello world" ''
      # ];});

      # "fork" by infinisil
      all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};

      # https://github.com/Infinisil/all-hies
      # all-hies.versions.ghc864
    };
  };

}
