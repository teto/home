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
    url = https://github.com/vhakulinen/gnvim;
    rev = "fd50f791a5004eb7ea6c29c8d10452f3609da06a";
    sha256 = "0lndpgmpzzq257n1nh7a72a1dfvkcfz8p0ax411ygjpp76zxjrp9";

    # gnvim detects its version from tags
    leaveDotGit = true;
    postFetch = ''
      set -x
      cd $out
      echo $PWD
      git fetch -vv --tags ${url}
      set +x
    '';
  };

  RUST_BACKTRACE=1;

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
