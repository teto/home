# mujmap
{ flakeSelf, stdenv }:
# mujmap-unstable =
let
  mujmap = flakeSelf.inputs.mujmap.packages.${stdenv.hostPlatform.system}.mujmap;
  fixConsoleVersion = ''
    sed -i \
      -e '/^features = \["std"\]$/d' \
      -e 's/, features = \["std"\]//' \
      Cargo.toml
    substituteInPlace Cargo.toml \
      --replace-fail 'version = "0.16"' 'version = "0.15"'
  '';
in
mujmap.overrideAttrs (oldAttrs: {
  postPatch = (oldAttrs.postPatch or "") + fixConsoleVersion;
  buildPhase = builtins.replaceStrings [ "--locked" ] [ "--offline" ] oldAttrs.buildPhase;
  checkPhase = builtins.replaceStrings [ "--locked" ] [ "--offline" ] oldAttrs.checkPhase;
  cargoArtifacts = oldAttrs.cargoArtifacts.overrideAttrs (oldCargoAttrs: {
    postPatch = (oldCargoAttrs.postPatch or "") + fixConsoleVersion;
    buildPhase = builtins.replaceStrings [ "--locked" ] [ "--offline" ] oldCargoAttrs.buildPhase;
  });
})
