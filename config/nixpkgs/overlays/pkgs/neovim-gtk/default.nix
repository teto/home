{ stdenv, fetchFromGitHub, rustPlatform
, gtk3, pkgconfig, wrapGAppsHook
}:

with rustPlatform;

buildRustPackage rec {
  name = "neovim-gtk-${version}";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "daa84";
    repo = "neovim-gtk";
    rev = "e1b5d8c79857d5ed68a4ca505a473b67326f7a46";
    sha256 = "1crrzxbl02y8b5737dlq95i1jsyy0z27gl51v905s95r684gklx3";
  };

  buildInputs = [ gtk3 ];

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  cargoSha256 = "1xfkx32p07vq3h1klk5rp8cn7fi7d84waqz1djd4mdldzc6hqw28";

  meta = with stdenv.lib; {
    description = "GTK ui for neovim written in rust using gtk-rs bindings. With ligatures support.";
    homepage = https://github.com/daa84/neovim-gtk;
    license = with licenses; [ gpl3 ];
    platforms = platforms.all;
  };
}
