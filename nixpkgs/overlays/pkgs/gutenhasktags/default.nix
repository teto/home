# { haskell, fetchFromGitHub, zlib, ghc}:

# haskell.lib.buildStackProject {
#   name = "gutenhasktags";
#   version = "0.1";

#   inherit ghc;

#   sourceRoot = ./.;

#   # git@github.com:rob-b/gutenhasktags.git
#   src = fetchFromGitHub {
#     owner = "rob-b";
#     repo = "gutenhasktags";
#     rev = "2a33f47aac9bcced8379f076c48ac6d33ba004ea";
#     sha256 = "1didzaf82is78s6kpi33ps3vcigbvnylp1c22plcn0sicz2a2kgi";
#   };

#   # might depend de hasktags a la rigueur
#   buildInputs = [ zlib ];

# }

{ mkDerivation, base, hspec, optparse-applicative, process
, QuickCheck, stdenv
, fetchFromGitHub
, lib
}:
mkDerivation {
  pname = "gutenhasktags";
  version = "0.1.0.0";
  # src = ./.;
  src = fetchFromGitHub {
    owner = "rob-b";
    repo = "gutenhasktags";
    rev = "2a33f47aac9bcced8379f076c48ac6d33ba004ea";
    sha256 = "1didzaf82is78s6kpi33ps3vcigbvnylp1c22plcn0sicz2a2kgi";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base optparse-applicative process ];
  testHaskellDepends = [ base hspec QuickCheck ];
  homepage = "https://github.com/githubuser/gutenhasktags";
  description = "TODO Initial project template from stack";
  license = lib.licenses.bsd3;
}

