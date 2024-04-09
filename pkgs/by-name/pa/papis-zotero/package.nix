{ lib, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "papis-zotero";
  version = "0.1.2";

  # Missing tests on Pypi
  src = fetchFromGitHub {
    owner = "papis";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XplBxoSycYV1jA/axYV54ChjLoQDx0cNfeOfmY/ct5k=";
  };

  propagatedBuildInputs = with python3.pkgs; [ papis ];

  doCheck = false;
  checkPhase = ''
    HOME=$(mktemp -d) pytest papis tests --ignore tests/downloaders
  '';

  meta = {
    description = "Powerful command-line document and bibliography manager";
    homepage = "https://github.com/papis/papis-zotero";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.teto ];
  };
}

