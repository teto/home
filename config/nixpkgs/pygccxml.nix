{ stdenv, pkgs, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pygccxml";
  version = "1.9.1";

  # src = fetchPypi {
  #   inherit pname version;
  #   sha256 = "0x1p62ff7ggb172rjr6sbdrjh1gl3ck3bwxsqlsix8i5wycwvnmv";
  # };
  src = fetchFromGitHub {
    owner  = "gccxml";
    repo   = "pygccxml";
    rev    = "v${version}";
    sha256 = "02ip03s0vmp7czzflbvf7qnybibfrd0rzqbc5zfmq3zmpnck3hvm";
  };


  propagatedBuildInputs = [ pkgs.castxml ];
  # buildInputs = [ setuptools_scm pytest pkgs.glibcLocales ];

  doCheck = false; # still fails
  checkPhase = ''
    python -m unittests.test_all
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/gccxml/pygccxml;
    description = "Python package for easy C++ declarations navigation";
    license = licenses.boost;
    maintainers = with maintainers; [ teto ];
  };
}

