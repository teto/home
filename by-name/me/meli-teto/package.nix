{
  flakeSelf,
  meli,
  rustPlatform,
}:

meli.overrideAttrs (old: rec {
  src = flakeSelf.inputs.meli-src;

  cargoBuildFlags = (old.cargoBuildFlags or [ ]) ++ [ "--features=debug-tracing" ];

  # meli's cargoDeps was created from the nixpkgs source before overrideAttrs,
  # so changing cargoHash alone does not recreate the vendor derivation.
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-u0AOXzlhJ4p6iAYU+FXL1UJ4ELTOaMOdr5PF/NL5z9g=";
  };
})
