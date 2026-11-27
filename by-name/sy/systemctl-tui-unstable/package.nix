{
  lib,
  systemctl-tui,
  fetchFromGitHub,
  rustPlatform,
}:
systemctl-tui.overrideAttrs (
  finalAttrs: old: {
    version = "0.8.0-unstable-2026-11-11";

    src = fetchFromGitHub {
      owner = "rgwood";
      repo = "systemctl-tui";
      rev = "e03d1f0790d5fd7f4396f9d3ed13b4b230d6bb2e";
      hash = "sha256-IcnCL9v4JQUn+5YhqlqBNUBidA1bd1Uu7nAtgqeLp9k=";
    };

    # versionCheckHook expects the binary to print `version`, but it reports Cargo.toml's
    doInstallCheck = false;

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src;
      hash = "sha256-SJl0AMK2hMdiWaPC4oEbHf4v/Yse1FSlfYFfiqbmxBs=";
    };
  }
)
