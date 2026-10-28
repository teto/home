{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage {
  pname = "release-please";
  version = "17.11.2";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "release-please";
    tag = "v17.11.2";
    hash = "sha256-OGLoO23w1hkL8vvja2B+yMsB+M+mUaIm7AigBMPPDDs=";
  };

  npmDepsHash = "sha256-zlYCIyaiHnTNfjYM0iP81E8M+6cPIhF/Z7WuCTAJ7b8=";
  npmBuildScript = "compile";

  meta = {
    description = "Automate changelog generation and GitHub release pull requests";
    homepage = "https://github.com/googleapis/release-please";
    license = lib.licenses.asl20;
    mainProgram = "release-please";
    platforms = lib.platforms.unix;
  };
}
