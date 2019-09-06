{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gitbatch";
  version = "0.5.0";

  goPackagePath = "https://github.com/isacikgoz/gitbatch";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "isacikgoz";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zynw5gr96a59x1qshzhhvld883ndf1plnw6l9dbhmff0wcfv6l1";
  };

  meta = with stdenv.lib; {
    description = "Running git UI commands";
    homepage = "https://github.com/isacikgoz/gitbatch";
    license = licenses.mit;
    maintainers = with maintainers; [ teto ];
  };
}

