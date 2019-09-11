{ stdenv, buildPythonPackage, fetchPypi, mupdf, swig }:
buildPythonPackage rec {
  pname = "PyMuPDF";
  version = "1.16.1";

  src = fetchPypi {
    inherit pname version;
    # rev = "${version}";

    sha256 = "094pk6lbycywwk23z39vljvpjq9g012b5ccmxijfxn47mff8qq3g";
  };

  patchPhase = ''
    substituteInPlace setup.py \
        --replace '/usr/include/mupdf' ${mupdf.dev}/include/mupdf
    '';
  # .dev
  buildInputs = [ mupdf swig ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python bindings for MuPDF's rendering library.";
    homepage = https://github.com/pymupdf/PyMuPDF;
    maintainers = with maintainers; [ teto ];
    license =  licenses.agpl3;
  };
}



