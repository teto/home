{ stdenv, buildPythonPackage, fetchFromGitHub }:
buildPythonPackage rec {
  pname = "python-doi";
  version = "now";

  src = fetchFromGitHub {
    owner = "alejandrogallo";
    repo = "python-doi";
    rev = "576c92355aa32c8970b3bf0a7549e2cf318fc43e";
    sha256 = "16g8azmr68ff3fryv8rzfmhw19r2w3ajj93r7d37paavaqchq3ya";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python library to work with Document Object Identifiers (doi)";
    homepage = https://github.com/alejandrogallo/python-doi;
    maintainers = with maintainers; [ teto ];
  };
}
