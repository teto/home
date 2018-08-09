# List of tips https://nixos.org/nix-dev/2015-January/015608.html
self: prev:
{
# pkgs.haskell.lib.doJailbreak
  # myHaskellOverlay = selfHaskell: prevHaskell: {

  #   # TODO
  # };

  # haskellPackages = prev.haskellPackages.extend myHaskellOverlay;
  # haskell overlay pkgs.haskell.lib.doJailbreak
# pkgs.haskell.lib.doJailbreak
#   jailbreak = true;
# haskellPackages.callCabal2nix to nixpkgs which means anyone can easily pull in GitHub packages and hackage packages that aren't in nixpkgs. 

# pkgs.haskell.lib.dontCheck
  haskellPackages = prev.haskellPackages.override {
    overrides = hself: hsuper: rec {  
      cabal-helper = prev.haskell.lib.doJailbreak hsuper.cabal-helper;
    };
  };



}
