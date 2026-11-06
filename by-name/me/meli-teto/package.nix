{
  capnproto,
  fetchgit,
  meli,
  nettle,
  rustPlatform,
}:
meli.overrideAttrs (old: rec {
  pname = old.pname + "-tetos";
  # Track development commits with: nix-update -F meli-teto --version=branch
  version = "0.8.13-unstable-2026-10-23";
  src = fetchgit {
    url = "https://git.meli-email.org/meli/meli.git";
    rev = "609630d8b47fb708c89aa9ef9fac8eb8de463cad";
    hash = "sha256-i83JOn27ChwUP9aU9xGcxWdrbQUiyWnqGDoVkJniuwU=";
  };

  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
    capnproto
    rustPlatform.bindgenHook
  ];
  buildInputs = (old.buildInputs or [ ]) ++ [ nettle ];

  # meli's cargoDeps was created from the nixpkgs source before overrideAttrs,
  # so changing cargoHash alone does not recreate the vendor derivation.
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-ILd4Ul6qsgeyD++swoAu+3yjX46bFz88d4e1tXCj+gU=";
  };
})
