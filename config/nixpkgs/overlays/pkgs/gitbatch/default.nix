{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gitbatch";
  version = "0.5.0";

  goPackagePath = "github.com/isacikgoz/gitbatch";

  # subPackages = [ "." ];

  # goDeps = 

  src = fetchGit {
    url = https://github.com/isacikgoz/gitbatch.git;
  };
  # fetchFromGitHub {
  #   owner = "isacikgoz";
  #   repo = pname;
  #   rev = "v${version}";
  #   sha256 = "sha256-vmxaZbwb98gZMm4CVEWC7AUn1Tvdxgqw6416jOAB7eQ=";
  # };

  meta = with stdenv.lib; {
    description = "Running git UI commands";
    homepage = "https://github.com/isacikgoz/gitbatch";
    license = licenses.mit;
    maintainers = with maintainers; [ teto ];
  };
}

