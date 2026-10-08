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
  version = "0.8.13-unstable-2026-10-08";
  src = fetchgit {
    url = "https://git.meli-email.org/meli/meli.git";
    rev = "7cf9e3c24cd60ffadbde47abf309ae0bca52cfe9";
    hash = "sha256-A48VXmpYOflAJL8nJAXXqG0aEjfP5ZVRa+0+EaXcc/Q=";
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
    hash = "sha256-6CdrdAvJbxnQRzhuT6DrR/DcgHvSw4UJHOoqfdtnxX0=";
  };
})
