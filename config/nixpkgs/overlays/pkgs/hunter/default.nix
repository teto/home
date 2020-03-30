{ stdenv, rustPlatform, fetchFromGitHub, IOKit ? null}:

assert stdenv.isDarwin -> IOKit != null;

rustPlatform.buildRustPackage rec {
  pname = "hunter-filemanager";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "rabite0";
    repo = "hunter";
    rev = "v${version}";
    sha256 = "0z28ymz0kr726zjsrksipy7jz7y1kmqlxigyqkh3pyh154b38cis";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  cargoSha256 = "0qnvw4n49m9shpql8bh3l19iymkfbbsd548gm1p7k26c2n9iwc7y";

  meta = with stdenv.lib; {
    description = "The fastest file manager in the galaxy!";
    homepage = https://github.com/rabite0/hunter;
    license = licenses.wtfpl;
    maintainers = [];
    platforms = platforms.unix;
  };
}
