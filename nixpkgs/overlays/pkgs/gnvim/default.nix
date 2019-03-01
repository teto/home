{ stdenv, fetchFromGitHub, rustPlatform
, gtk3, pkgconfig, wrapGAppsHook
, webkitgtk24x-gtk3
}:

with rustPlatform;

#TODO fix name
buildRustPackage rec {
  name = "gnvim-${version}";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "vhakulinen";
    repo = "gnvim";
    rev = "b279ea69bf280aa2f8f57a10e408d6810f55ef82";
    sha256 = "1mvw6hq44dg5d9dhxki4vl1f345j3zwxkq4vpdghks18ixwg9vg9";
  };

  # TODO might need to wrap with this
  # GNVIM_RUNTIME_PATH=./runtime

  # webkitgtk24x-gtk3
  buildInputs = [ gtk3 webkitgtk24x-gtk3 ];

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  cargoSha256 = "020dl38jv7pskks9dxj0y7mfjdx5sl77k2bhpccqdk63ihdscx92";

  meta = with stdenv.lib; {
    description = "GUI for neovim, without any web bloat";
    homepage = https://github.com/vhakulinen/gnvim;
    license = with licenses; [ mit ];
    platforms = platforms.linux;
  };
}
