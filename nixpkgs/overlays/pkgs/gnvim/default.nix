{ stdenv, fetchFromGitHub, rustPlatform
, gtk3, pkgconfig, wrapGAppsHook
, webkitgtk24x-gtk3
, git
, fetchgit
}:

with rustPlatform;

buildRustPackage rec {
  name = "gnvim-${version}";
  version = "0.1.1";

  src = fetchgit rec {
    postFetch = ''
      set -x
      pwd
      cd $out
      ls -la
      git fetch -vv --tags
      exit 1
    '';
    url = "https://github.com/vhakulinen/gnvim";
    rev = "b279ea69bf280aa2f8f57a10e408d6810f55ef82";
    sha256 = "1r1c2g07qy40xs0h8vaimjd5x4q95cgw3mc0kgv8n7lyghsrjyp4";
    leaveDotGit = true;
  };

  # src = fetchFromGitHub {
  #   owner = "vhakulinen";
  #   repo = "gnvim";
  #   rev = "b279ea69bf280aa2f8f57a10e408d6810f55ef82";
  #   sha256 = "1g1icmp1ykpx56xkyqmnfsf9r1ry25pwwhk4z3j4g5b7xl1p4rcz";
  #   leaveDotGit = true;
  #   # fetchSubmodules = true;
  # };

  # TODO might need to wrap with this
  # GNVIM_RUNTIME_PATH=./runtime

  # webkitgtk24x-gtk3
  buildInputs = [ gtk3 webkitgtk24x-gtk3 ];

  nativeBuildInputs = [ pkgconfig wrapGAppsHook git ];

  cargoSha256 = "020dl38jv7pskks9dxj0y7mfjdx5sl77k2bhpccqdk63ihdscx92";

  meta = with stdenv.lib; {
    description = "GUI for neovim, without any web bloat";
    homepage = https://github.com/vhakulinen/gnvim;
    license = with licenses; [ mit ];
    platforms = platforms.linux;
  };
}
