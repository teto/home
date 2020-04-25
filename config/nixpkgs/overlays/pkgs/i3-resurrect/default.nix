{ stdenv, python, fetchFromGitHub, buildPythonApplication
, psutil
, natsort
, click
, i3ipc
}:
buildPythonApplication rec {
	pname = "i3-resurrect";
	version = "1.4.3";

    src = fetchFromGitHub {
      owner = "JonnyHaystack";
      repo = "i3-resurrect";
      rev = version;
      sha256 = "15y8rdn6ir590r194md4bf948va04g5n3yyv2csc0dahadphdqi9";
    };

    doCheck = false;
    propagatedBuildInputs = [
      psutil
      natsort
      click
      i3ipc
    ];

    meta = with stdenv.lib; {
      description = "Simple solution to saving and restoring i3 workspaces.";
      license = licenses.gpl3;
      maintainers = [ maintainers.teto ];
    };
}

