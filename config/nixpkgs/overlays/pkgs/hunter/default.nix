{ stdenv
, callPackage
, makeRustPlatform
, fetchFromGitHub, IOKit ? null
}:

assert stdenv.isDarwin -> IOKit != null;

# let
#   src = fetchFromGitHub {
#       owner = "mozilla";
#       repo = "nixpkgs-mozilla";
#       # commit from: 2019-05-15
#       rev = "9f35c4b09fd44a77227e79ff0c1b4b6a69dff533";
#       sha256 = "18h0nvh55b5an4gmlgfbvwbyqj91bklf1zymis6lbdh75571qaz0";
#    };
# in
# with import "${src.out}/rust-overlay.nix" pkgs pkgs;
# The date of the nighly version to use.

let
  # date = "2020-3-30";
  date = "2019-07-30";
  mozillaOverlay = fetchFromGitHub {
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    rev = "e912ed483e980dfb4666ae0ed17845c4220e5e7c";
    sha256 = "08fvzb8w80bkkabc1iyhzd15f4sm7ra10jn32kfch5klgl0gj3j3";
  };
  mozilla = callPackage "${mozillaOverlay.out}/package-set.nix" {};
  rustNightly = (mozilla.rustChannelOf { inherit date; channel = "nightly"; }).rust;
  rustPlatform = makeRustPlatform {
    cargo = rustNightly;
    rustc = rustNightly;
  };
in
rustPlatform.buildRustPackage rec {
  pname = "hunter-filemanager";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "rabite0";
    repo = "hunter";
    rev = "v${version}";
    sha256 = "0z28ymz0kr726zjsrksipy7jz7y1kmqlxigyqkh3pyh154b38cis";
  };

  RUSTC_BOOTSTRAP=1;

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
