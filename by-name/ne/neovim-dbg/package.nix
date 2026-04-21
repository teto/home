{
  flakeSelf,
  stdenv,
}:
(flakeSelf.inputs.neovim-nightly-overlay.packages.${stdenv.hostPlatform.system})
.neovim-debug.overrideAttrs
  {
    postInstall = ''
      set -x
      mv $out/bin/nvim $out/bin/nvim-debug
      # where does that come from ? points at "nvim" executable
      rm -rf $out/lib/debug/.build-id
    '';

    # versionHook fails otherwise
    doCheck = false;
    doInstallCheck = false;
  }
