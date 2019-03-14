{ stdenv, fetchFromGitHub, rustPlatform
, gtk3, pkgconfig, wrapGAppsHook
, webkitgtk24x-gtk3
, git
, fetchgit
, gnome3
}:

with rustPlatform;

buildRustPackage rec {
  name = "gnvim-${version}";
  version = "0.1.1";

  src = fetchgit rec {
    url = "https://github.com/vhakulinen/gnvim";
    rev = "cff6810bc91514a8fd56c8923f01ad937d8c766a";
    sha256 = "0g968ycdzljq6d9q99wngj16ak783az357c2ns0hbcfm7awiw8k1";

    # gnvim detects its version from tags
    leaveDotGit = true;
    postFetch = ''
      cd $out
      git fetch -vv --tags ${url}
    '';
  };

  # TODO might need to wrap with this
  # GNVIM_RUNTIME_PATH=./runtime

  buildInputs = [ gtk3 gnome3.webkitgtk.dev];

  nativeBuildInputs = [ pkgconfig wrapGAppsHook git ];

  cargoSha256 = "020dl38jv7pskks9dxj0y7mfjdx5sl77k2bhpccqdk63ihdscx92";

  meta = with stdenv.lib; {
    description = "GUI for neovim, without any web bloat";
    homepage = https://github.com/vhakulinen/gnvim;
    license = with licenses; [ mit ];
    platforms = platforms.linux;
  };
}
