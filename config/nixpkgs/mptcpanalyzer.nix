{
  # pkgs ? import <nixpkgs> {}
lib
, fetchFromGitHub
, buildPythonApplication
, stevedore, cmd2
# might be useless ? depends on cmd2
, pyperclip
, pandas, matplotlib, pyqt5

# can be overriden with the one of your choice
, tshark
}:

# with pkgs.python3Packages;
let

  filter-src =  builtins.filterSource (name: type:
    let baseName = baseNameOf (toString name); in
    lib.cleanSourceFilter name type && !(
    lib.hasSuffix ".pcap" baseName
    || lib.hasSuffix ".csv" baseName
    || baseName == "tags"
    ));

in
buildPythonApplication rec {
	pname = "mptcpanalyzer";
	version = "0.1";
    # src = fetchFromGitHub {
    #   owner = "teto";
    #   repo = "mptcpanalyzer";
    #   rev = "${version}";
    #   # sha256 = ;
    # };
    # todo filter
    # filter-src
	src =  builtins.filterSource (name: type: true) /home/teto/mptcpanalyzer;
    # enableCheckPhase=false;
    doCheck = false;
    /* skipCheck */
	# buildInputs = [  stevedore pandas matplotlib  ];
    # to build the doc sphinx
    # TODO package tshark
    propagatedBuildInputs = [ stevedore cmd2 pyperclip pandas 
    # we want gtk because qt is so annying on nixos
    (matplotlib.override { enableGtk3=true;})
    pyqt5
    tshark pyperclip ];
	/* propagatedBuildInputs =  [ stevedore pandas matplotlib pyqt5 ]; */

    meta = with lib; {
      description = "pcap analysis tool specialized for multipath TCP";
      maintainers = [ maintainers.teto ];
      # dunno why but taht fails
      # licence = licences.gpl3;
    };
}
