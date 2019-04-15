{ stdenv, buildPythonApplication, stevedore, cmd2, pandas, sortedcontainers, matplotlib, pulp, pyqt5 }:
buildPythonApplication {
	pname = "mptcpnumerics";
	version = "0.1";
    # src = fetchFromGitHub {
    #   owner = "teto";
    #   repo = "mptcpanalyzer";
    #   rev = "${version}";
    #   # sha256 = ;
    # };
	src =  builtins.filterSource (name: type: true) /home/teto/mptcpnumerics;
    # enableCheckPhase=false;
    doCheck = false;
    /* skipCheck */
	# buildInputs = [  stevedore pandas matplotlib  ];
    # to build the doc sphinx
    # TODO package tshark
    propagatedBuildInputs = [
      stevedore cmd2
      pandas
      sortedcontainers
      # we want gtk because qt is so annying on nixos
      # at the same time "The Gtk3 backend requires PyGObject or pgi"
      (matplotlib.override { enableGtk3=true;})
      pulp
      pyqt5
    ];
	/* propagatedBuildInputs =  [ stevedore pandas matplotlib pyqt5 ]; */

    meta = with stdenv.lib; {
      description = "tool specialized for multipath TCP";
      maintainers = [ maintainers.teto ];
    };
}
