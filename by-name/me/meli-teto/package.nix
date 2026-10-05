{
  flakeSelf,
  meli,
  rustPlatform,
  stdenv,
  lib,
}:
let
  meli-src = flakeSelf.inputs.meli-src;
  #   withNotmuch ? true,
in
meli.overrideAttrs (old: rec {
  pname = old.pname + "-tetos";
  version = meli-src.shortRev or "dirty";
  src = meli-src;

  # meli's cargoDeps was created from the nixpkgs source before overrideAttrs,
  # so changing cargoHash alone does not recreate the vendor derivation.
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-VICsXhci8T1cDxYHmyIrbuzjouQT3ZnxneIlSM5T8pE=";
  };
})
