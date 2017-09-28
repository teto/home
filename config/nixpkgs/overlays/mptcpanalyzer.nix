with import <nixpkgs> {};
with pkgs.python36Packages;

buildPythonPackage rec {
	name = "mptcpanalyzer-${version}";
	version = "0.1";
	src = ./.;
    # enableCheckPhase=false;
    doCheck = false;
    /* skipCheck */
	# buildInputs = [  stevedore pandas matplotlib  ];
    # to build the doc sphinx
    # TODO package tshark
	propagatedBuildInputs =  [ stevedore cmd2 pyperclip pandas matplotlib pyqt5 tshark-local ];
	/* propagatedBuildInputs =  [ stevedore pandas matplotlib pyqt5 ]; */
}
