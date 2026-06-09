{
  pimsync,
  flakeSelf,
  rustPlatform,
}:
pimsync.overrideAttrs (
  drv:
  let
    pimsync-src = flakeSelf.inputs.pimsync-src;
  in
  rec {

    version = "g${pimsync-src.shortRev}";
    src = pimsync-src;

    env.PIMSYNC_VERSION = "${version}";

    useFetchCargoVendor = true;

    # failed to get vstorage
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-utLmQXVi9uyzDojlMvL5iP3zaAb2uHibYT8xnOackgg=";
    };

  }
)
