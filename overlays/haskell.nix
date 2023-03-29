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
        final.pkg-config
      ];
  };

in
{
  nhs92 = final.mkShell {
    name = "ghc9-haskell-env";
    packages =
      let
        pkgs = final.pkgs;
        ghcEnv = pkgs.haskell.packages.ghc92.ghcWithPackages (hs: [
          hs.haskell-language-server
          hs.cabal-install
        ]);
      in
      [
        ghcEnv
        pkgs.pkg-config
      ];
  };

  nhs94 = final.mkShell {
    name = "ghc9-haskell-env";
    packages =
      let
        pkgs = final.pkgs;
        ghcEnv = pkgs.haskell.packages.ghc94.ghcWithPackages (hs: [
          hs.ghc
          hs.haskell-language-server
          hs.cabal-install
          prev.cairo
        ]);
      in
      [
        # pkgs.haskell.compiler.ghc94
        ghcEnv
        final.pkg-config
      ];
  };

  nhs96 = mkGhcShell "96";
  #   name = "ghc96-haskell-env";
  #   packages =
  #     let
  #       pkgs = final.pkgs;
  #       ghcEnv = pkgs.haskell.packages.ghc94.ghcWithPackages (hs: [
  #         hs.ghc
  #         hs.haskell-language-server
  #         hs.cabal-install
  #         prev.cairo
  #       ]);
  #     in
  #     [
  #       # pkgs.haskell.compiler.ghc94
  #       ghcEnv
  #       final.pkg-config
  #     ];
  # };

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
