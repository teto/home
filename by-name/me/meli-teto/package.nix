{
  flakeSelf,
  meli,
  rustPlatform,
}:
let 
  meli-src = flakeSelf.inputs.meli-src;
#   withNotmuch ? true,
in
meli.overrideAttrs (old: rec {
  pname = old.pname + "-tetos";
  version = meli-src.shortRev or "dirty";
  src = meli-src;

  # cargoBuildFlags = (old.cargoBuildFlags or [ ]) ++ [ "--features=debug-tracing" ];

  # Avoid downloading Unicode data during the sandboxed build when the generated
  # table shipped by upstream is already present.
  patches = (old.patches or [ ]) ++ [
    (builtins.toFile "meli-skip-unicode-download.patch" ''
      diff --git a/melib/build.rs b/melib/build.rs
      --- a/melib/build.rs
      +++ b/melib/build.rs
      @@ -80,9 +80,6 @@ fn main() -> Result<(), std::io::Error> {
           println!("cargo:rerun-if-env-changed=UNICODE_REGENERATE_TABLES");
           println!("cargo:rerun-if-changed=build.rs");
           println!("cargo:rerun-if-changed={MOD_PATH}");
      -
      -    eprintln!("Fetching unicode data tables for unicode version {version:?}");
      -    let ucd = Ucd::get(&version).unwrap();
           let mod_path = Path::new(MOD_PATH);
           if mod_path.exists() {
               eprintln!(
      @@ -90,6 +87,9 @@ fn main() -> Result<(), std::io::Error> {
               );
               return Ok(());
           }
      +
      +    eprintln!("Fetching unicode data tables for unicode version {version:?}");
      +    let ucd = Ucd::get(&version).unwrap();
           let mut line_break_table: Vec<(u32, u32, LineBreakClass)> = Vec::with_capacity(3800);
           for line in ucd.line_break_table.lines() {
               if line.starts_with('#') || line.starts_with(' ') || line.is_empty() {
    '')
  ];
  # postPatch = ''
  #
  #   cat melib/src/notmuch/mod.rs
  #   '';

  # meli's cargoDeps was created from the nixpkgs source before overrideAttrs,
  # so changing cargoHash alone does not recreate the vendor derivation.
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-w1jp/aVPYXZhI0Z8RiV6VBJ/YDGgdMpOIlam0Git4TM=";
  };
})
