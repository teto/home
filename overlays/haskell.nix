final: prev:
let 
 mkGhcShell = version: let 
   ghc = final.pkgs.haskell.packages."ghc${version}";
 in
   final.mkShell {
    name = "ghc${version}-haskell-env";
    packages =
      let
        ghcEnv = ghc.ghcWithPackages (hs: [
          hs.ghc
          # hs.haskell-language-server
          hs.cabal-install
          # prev.cairo
        ]);
      in
      [
        ghcEnv
		# ghc
        final.pkg-config
      ];
  };

in
{
 nhs92 = mkGhcShell "92";
 nhs94 = mkGhcShell "94";
 nhs96 = mkGhcShell "96";


  # haskell = prev.haskell // {

  #   # to work around a stack bug (stack ghc is hardcoded)
  #   # compiler = prev.haskell.compiler // { ghc802 = prev.haskell.compiler.ghc844; };

  #   packageOverrides = hself: hold: with prev.haskell.lib; rec {
  #     # useful to fetch newer libraries with callHackage
  #     # gutenhasktags = dontCheck (hprev.callPackage ./pkgs/gutenhasktags {});

  #         # for newer nixpkgs (March 2020)
  #         # base-compat = doJailbreak (hold.base-compat);
  #         # time-compat = doJailbreak (hold.time-compat);
  #   };
  # };
}
