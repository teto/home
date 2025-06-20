{ meli, flakeSelf, rustPlatform, ... }:

    meli.overrideAttrs (drv: rec {
    name = "meli-${version}";
    version = "g${flakeSelf.inputs.meli-src.shortRev}";
    src = flakeSelf.inputs.meli-src;

    cargoPatches = [ ];
    useFetchCargoVendor = true;

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-OyOLAw3HzXY85Jwolh4Wqjmm6au6wRwGq5WkicOt5eg=";
    };

    checkFlags = drv.checkFlags ++ [
      "--skip=test_imap_watch"
    ];
  })
