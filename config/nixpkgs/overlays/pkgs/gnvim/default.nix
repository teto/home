{ stdenv, fetchFromGitHub, rustPlatform
, gtk3, pkgconfig, wrapGAppsHook
, webkitgtk24x-gtk3
, git
, fetchgit
, gnome3
}:

with rustPlatform;

buildRustPackage rec {
  pname = "gnvim";
  version = "0.1.2";

  # GNVIM_RUNTIME_PATH="
  src = fetchgit rec {

    url = https://github.com/vhakulinen/gnvim;
    rev = "4b248cda4a6858544c6dbe9a4ad79796a7008247";
    sha256 = "1f5vfi5nxn9zscad2cgjdm5sdgi0jrnmhswyhr05h55y6iqcnnb4";

    # url = https://github.com/teto/gnvim;
    # rev = "c98cb99cb4009c82c45c41f668b468659595083d";
    # sha256 = "0y4yi4w3bdswnfw73n4yn68bx5kl3ikkp21yahgp3hnxx12abv6d";

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

  cargoSha256 = "0y4yi4w3bdswnfw73n4yn68bx5kl3ikkp21yahgp3hnxx12abv6d";

  # export GNVIM_RUNTIME_PATH=/nix/store/i0z9jkx4hak08hikdksnf0w487lfxkdp-gnvim-0.1.2/share/gnvim/runtime 
  postInstall= ''
    make install PREFIX=$out
    wrapProgram $out/bin/gnvim --set GNVIM_RUNTIME_PATH $out/share/gnvim/runtime
  '';

  meta = with stdenv.lib; {
    description = "GUI for neovim, without any web bloat";
    homepage = https://github.com/vhakulinen/gnvim;
    license = with licenses; [ mit ];
    platforms = platforms.linux;
  };
}
