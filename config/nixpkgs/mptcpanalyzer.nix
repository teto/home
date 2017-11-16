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
	name = "mptcpanalyzer-${version}";
	version = "0.1";
    # src = fetchFromGitHub {
    #   owner = "teto";
    #   repo = "mptcpanalyzer";
    #   rev = "${version}";
    #   # sha256 = ;
    # };
    # todo filter
	src = filter-src /home/teto/mptcpanalyzer;
    # enableCheckPhase=false;
    doCheck = false;
    /* skipCheck */
	# buildInputs = [  stevedore pandas matplotlib  ];
    # to build the doc sphinx
    # TODO package tshark
    propagatedBuildInputs = [ stevedore cmd2 pyperclip pandas matplotlib pyqt5
    tshark pyperclip ];
	/* propagatedBuildInputs =  [ stevedore pandas matplotlib pyqt5 ]; */

    meta = {
      # licences = 
    };
}
