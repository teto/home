{ stdenv
, buildPythonApplication
, fetchFromGitHub
, fetchPypi
, bibtool
, pymupdf
}:
# stdenv.mkDerivation rec {
buildPythonApplication {
  pname = "termpdf.py";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "dsanson";
    repo = "termpdf.py";
    rev = "ef8b3c05d758d139b8b028495718c3123445536c";
    sha256 = "0smnx61cg8si9paviy6sgzgqkq6idiw324m1ww7sm8f6jyjdfncg";
  };
  # src = fetchFromGitHub {
  #   owner = "papis";
  #   repo = "papis-rofi";
  #   rev = version;
  #   sha256 = "0iy6r29ncpca7v4ibnig2mh93nkrqvy4nhmzkq6flxmryghfzhwn";
  # };

  buildInputs = [ bibtool pymupdf ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Linux kernel config generator";
    homepage = https://github.com/nichoski/kergen;
    maintainers = with maintainers; [ teto ];
    license =  licenses.asl20;
  };
}




