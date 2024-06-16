{
  stdenv,
  fetchFromGitHub,
  makeRustPlatform,
  # , rustPlatform
  openssl,
  zstd,
  pkg-config,
  fenix,
}:

let
  toolchain = fenix.packages.${stdenv.hostPlatform.system}.minimal.toolchain;

  rustPlatform = (
    makeRustPlatform {
      cargo = toolchain;
      rustc = toolchain;
    }
  );
in
# (fenix.packages.${stdenv.hostPlatform.system}.latest.withComponents [
# "cargo"
# "clippy"
# "rust-src"
# "rustc"
# "rustfmt"
# ]);
rustPlatform.buildRustPackage (
  let
    version = "unstable-2023-08-28";
    rev = "29b3bd3581157aaa335aa070412fa6c2da3be466";
    owner = "hakoerber";
    pname = "git-repo-manager";
    src = fetchFromGitHub {
      owner = owner;
      repo = pname;
      rev = rev;
      hash = "sha256-K0nqEnu1d3EWRHQn3zj0Is8Z6EjbMJTwGH9I0v9DmgY=";
    };
  in
  {
    inherit version pname;
    inherit src;

    cargoLock = {
      lockFile = ./Cargo.lock;
    };

    nativeBuildInputs = [ pkg-config ];

    buildInputs = [
      openssl
      zstd
    ];

    # buildFeatures = additionalFeatures [ (lib.optional withDefaultFeatures "default") ];

    # meta = with lib; {
    #   description = "A modern shell written in Rust";
    #   homepage = "https://www.nushell.sh/";
    #   license = licenses.mit;
    #   maintainers = with maintainers; [ Br1ght0ne johntitor marsam ];
    #   mainProgram = "nu";
    # };
  }
)
