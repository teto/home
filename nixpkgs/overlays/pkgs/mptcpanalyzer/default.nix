{
stdenv
, fetchFromGitHub
, buildPythonApplication
, stevedore, cmd2
# might be useless ? depends on cmd2
, pyperclip
, pandas, matplotlib, pyqt5

# can be overriden with the one of your choice
, tshark
}:

buildPythonApplication rec {
	pname = "mptcpanalyzer";
	version = "0.1";

    src = fetchFromGitHub {
      owner = "teto";
      repo = "mptcpanalyzer";
      rev = "${version}";
      # sha256 = ;
    };

    doCheck = false;

    # to build the doc sphinx
    propagatedBuildInputs = [
      stevedore cmd2 pyperclip pandas 
      # we want gtk because qt is so annying on nixos
      (matplotlib.override { enableGtk3=true;})
      pyqt5
      tshark 
    ];

    meta = with stdenv.lib; {
      description = "pcap analysis tool specialized for multipath TCP";
      maintainers = [ maintainers.teto ];
      license = licenses.gpl3;
    };
}
