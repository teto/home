{ stdenv, python, fetchFromGitHub, buildPythonApplication
, stevedore, cmd2, pandas, sortedcontainers, matplotlib, pulp, pyqt5
, sympy, lib }:
buildPythonApplication rec {
	pname = "mptcpnumerics";
	version = "0.1";

    src = fetchFromGitHub {
      owner = "teto";
      repo = "mptcpnumerics";
      rev = "8f021b873aa1b003298e9f1ae22e96683a96f057";
      sha256 = "1pqbbmlgxxc1b5a3psp2vmlii1bhmy574mpacindvw0kphi2b6kf";
    };

	# src =  builtins.filterSource (name: type: true) /home/teto/mptcpnumerics;
    # enableCheckPhase=false;
    doCheck = false;
    /* skipCheck */
	# buildInputs = [  stevedore pandas matplotlib  ];
    # to build the doc sphinx
    # TODO package tshark
    propagatedBuildInputs = [
      stevedore
      sympy
      cmd2
      pandas
      sortedcontainers
      # we want gtk because qt is so annying on nixos
      # at the same time "The Gtk3 backend requires PyGObject or pgi"
      (matplotlib.override {enableGtk3=true;})
      pulp
      pyqt5
    ];
	/* propagatedBuildInputs =  [ stevedore pandas matplotlib pyqt5 ]; */

    meta = with lib; {
      description = "tool specialized for multipath TCP";
      maintainers = [ maintainers.teto ];
    };
}
