{
  lib,
  fetchpatch,
  python3,
  pkgsCross,
  pixiecore,
}:

pixiecore.overrideAttrs (old: {
  pname = "pixiecore-arm64";

  patches = (old.patches or [ ]) ++ [
    (fetchpatch {
      name = "pixiecore-pr-121-arm64.patch";
      url = "https://patch-diff.githubusercontent.com/raw/danderson/netboot/pull/121.patch";
      hash = "sha256-D6oTY/R64vcy19s0qy/K1sVdpP3quUPi1IbPW4ecYEQ=";
      includes = [
        "Makefile"
        "cmd/pixiecore/main.go"
        "pixiecore/http.go"
        "pixiecore/pixiecore.go"
        "pixiecore/pxe.go"
      ];
    })
  ];

  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
    pkgsCross.aarch64-multiplatform.stdenv.cc
    python3
  ];

  postPatch = (old.postPatch or "") + ''
    substituteInPlace Makefile \
      --replace-fail 'CROSS=aarch64-linux-gnu-' 'CROSS=${pkgsCross.aarch64-multiplatform.stdenv.cc.targetPrefix}'

    python3 - <<'PY'
    from pathlib import Path

    path = Path("pixiecore/dhcp.go")
    source = path.read_text()
    old_arch = "\t\tfwtype = FirmwareEFIBC\n\tdefault:"
    new_arch = (
        "\t\tfwtype = FirmwareEFIBC\n"
        "\tcase 11:\n"
        "\t\tmach.Arch = Arm64\n"
        "\t\tfwtype = FirmwareEFIArm64\n"
        "\tdefault:"
    )
    old_firmware = "case FirmwareEFI32, FirmwareEFI64, FirmwareEFIBC:"
    new_firmware = "case FirmwareEFI32, FirmwareEFI64, FirmwareEFIBC, FirmwareEFIArm64:"

    assert source.count(old_arch) == 1
    assert source.count(old_firmware) == 1
    path.write_text(source.replace(old_arch, new_arch).replace(old_firmware, new_firmware))
    PY
  '';

  meta = old.meta // {
    description = "PXE boot server with ARM64 UEFI client support";
  };
})
