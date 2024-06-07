# it now has a flake.nix so this could probably be removed/tweaked
{ compilerName ? "ghc884"
}:

let
  pkgs = nixpkgs.pkgs;

  nixpkgsRev = "d3f7e969b9860fb80750147aeb56dab1c730e756";
  nixpkgs = import
    (fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${nixpkgsRev}.tar.gz";
      sha256 = "13z5lsgfgpw2wisglicy7krjrhypcc2y7krzxn54ybcninyiwhsn";
    })
    { };

  hsEnv = myHaskellPackages.ghcWithPackages (hs: [
    hs.haskell-language-server
    myHaskellPackages.cabal-install
    hs.hasktags
    pkgs.zlib

  ]);
  myHaskellPackages = pkgs.haskell.packages."${compilerName}";
in
pkgs.mkShell rec {
  name = "Frames-utils";
  buildInputs = with pkgs; [
    blas
    glib
    gsl
    hsEnv
    lapack
    pkg-config
    zlib
  ];

  # see https://discourse.nixos.org/t/shared-libraries-error-with-cabal-repl-in-nix-shell/8921/9
  LD_LIBRARY_PATH = nixpkgs.lib.makeLibraryPath buildInputs;
}
