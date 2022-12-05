{ lib
, buildPythonApplication
, fetchFromGitHub
, fetchPypi
, bibtool
, pybtex
, pymupdf
, pynvim
, pyperclip
, roman
, pdfrw
, pagelabels
, setuptools
}:
buildPythonApplication {
  pname = "termpdf.py";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "dsanson";
    repo = "termpdf.py";
    rev = "d47c764f03394fdd8b719b1f877f3496a865e5ff";
    sha256 = "M5a1gHK7UJZSJeUquQGgoaM1GDVZ+zfQ2NcWHnfIz4o=";
  };
  # src = fetchFromGitHub {
  #   owner = "papis";
  #   repo = "papis-rofi";
  #   rev = version;
  #   sha256 = "0iy6r29ncpca7v4ibnig2mh93nkrqvy4nhmzkq6flxmryghfzhwn";
  # };

  # pyperclip/ fizz ?
  propagatedBuildInputs = [
    bibtool
    pybtex
    pymupdf
    pyperclip
    roman
    pagelabels
    pdfrw
    pynvim
    setuptools
  ];

  doCheck = false;

  meta = with lib; {
    description = "Linux kernel config generator";
    homepage = https://github.com/dsanson/termpdf.py;
    maintainers = with maintainers; [ teto ];
    license = licenses.mit;
  };
}




