{ pkgs ? import <nixpkgs> {}
, pythonPackages
}:

with pkgs.python3Packages;
buildPythonPackage rec {
	name = "mptcpanalyzer-${version}";
	version = "0.1";
	src = /home/teto/mptcpanalyzer;
    # enableCheckPhase=false;
    doCheck = false;
    /* skipCheck */
	# buildInputs = [  stevedore pandas matplotlib  ];
    # to build the doc sphinx
    # TODO package tshark
    propagatedBuildInputs = with pythonPackages; [ stevedore cmd2 pyperclip pandas matplotlib pyqt5
    pkgs.tshark-local pyperclip ];
	/* propagatedBuildInputs =  [ stevedore pandas matplotlib pyqt5 ]; */
}
