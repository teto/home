
# { haskell }:
{ hello, haskell, fetchFromGitHub, lib}:
  hello
# haskell.packages.ghc9103.callPackage (
# {
#   base,
#   hspec,
#   optparse-applicative,
#   process,
#   QuickCheck,
#   stdenv,
# }:
# {
#   pname = "gutenhasktags";
#   version = "0.1.0.0";
#   # src = ./.;
#   src = fetchFromGitHub {
#     owner = "rob-b";
#     repo = "gutenhasktags";
#     rev = "2a33f47aac9bcced8379f076c48ac6d33ba004ea";
#     sha256 = "1didzaf82is78s6kpi33ps3vcigbvnylp1c22plcn0sicz2a2kgi";
#   };
#   isLibrary = false;
#   isExecutable = true;
#   executableHaskellDepends = [
#     base
#     optparse-applicative
#     process
#   ];
#   testHaskellDepends = [
#     base
#     hspec
#     QuickCheck
#   ];
#   homepage = "https://github.com/githubuser/gutenhasktags";
#   description = "TODO Initial project template from stack";
#   license = lib.licenses.bsd3;
# }) {}
