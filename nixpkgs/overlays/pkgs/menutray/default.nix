with import <nixpkgs> {};

let
  myPerl = (perl.withPackages (p: []));
in
stdenv.mkDerivation rec {
  pname = "menutray";
  version = "1.1";

  src = fetchurl {
    url = "http://pelulamu.net/${pname}/${pname}-${version}-src.tar.gz";
    sha256 = "0qcxcnqz2nlwfzlrn115kkp3n8dd7593h762vxs6vfqm13i39lq1";
  };

  nativeBuildInputs =
    [ myPerl
    ];

}
