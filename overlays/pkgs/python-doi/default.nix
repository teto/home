{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:
buildPythonPackage rec {
  pname = "python-doi";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "papis";
    repo = "python-doi";
    rev = "v${version}";
    # rev = "576c92355aa32c8970b3bf0a7549e2cf318fc43e";
    sha256 = "1wa5inh2a0drjswrnhjv6m23mvbfdgqj2jb8fya7q0armzp7l6fr";
  };

  doCheck = false;

  meta = with lib; {
    description = "Python library to work with Document Object Identifiers (doi)";
    homepage = "https://github.com/alejandrogallo/python-doi";
    maintainers = with maintainers; [ teto ];
  };
}
