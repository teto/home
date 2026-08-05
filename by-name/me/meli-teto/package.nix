{
  flakeSelf,
  meli,
  rustPlatform,
  stdenv,
  lib,
}:

#   withNotmuch ? true,
meli.overrideAttrs (old: rec {
  pname = old.pname + "-tetos";
  src = flakeSelf.inputs.meli-src;

  # cargoBuildFlags = (old.cargoBuildFlags or [ ]) ++ [ "--features=debug-tracing" ];

  patches = [
    ./speedup-notmuch.patch
    ./speedup-notmuch2.patch
  ];
  postInstall =
    old.postInstall or ""
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd meli \
        --bash <($out/bin/meli completions bash) \
        --zsh <($out/bin/meli completions zsh) \
        --fish <($out/bin/meli completions fish)
    '';

  # postPatch = ''
  #
  #   cat melib/src/notmuch/mod.rs
  #   '';

  # meli's cargoDeps was created from the nixpkgs source before overrideAttrs,
  # so changing cargoHash alone does not recreate the vendor derivation.
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-u0AOXzlhJ4p6iAYU+FXL1UJ4ELTOaMOdr5PF/NL5z9g=";
  };
})
