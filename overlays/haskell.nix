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
          hs.haskell-language-server
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
}
