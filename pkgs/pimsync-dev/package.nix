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
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-vnBk0uojWDM9PS8v5Qda2UflmIFZ09Qp9l25qTTWGMc=";
    };

  }
)
