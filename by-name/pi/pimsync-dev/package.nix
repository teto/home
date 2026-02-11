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

    PIMSYNC_VERSION = "${version}";

    useFetchCargoVendor = true;

    # failed to get vstorage
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-0KNdgHigHJN9gKsDfC0aQUWkSYsWABnJrvsK9+Z2dMk=";
    };

  }
)
