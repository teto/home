{
  lib,
  stdenv,
  autoPatchelfHook,
  fetchurl,
  gzip,
}:

let
  version = "0.10.5";

  sources = {
    aarch64-linux = {
      arch = "arm64";
      hash = "sha256-I2pJ7cAIMoLFcRyL/LH8JwGuHFKGg8IxFYAMX1+uqK0=";
    };
    x86_64-linux = {
      arch = "x64";
      hash = "sha256-nVX0CbYv5eOWR2uoL4i4AWphfHmRKWDd4tBqN5hA9I8=";
    };
  };

  source = sources.${stdenv.hostPlatform.system};
in
stdenv.mkDerivation {
  pname = "gloomberb";
  inherit version;

  src = fetchurl {
    url = "https://github.com/gloom-sh/gloomberb/releases/download/v${version}/gloomberb-linux-${source.arch}.gz";
    inherit (source) hash;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    gzip
  ];

  dontUnpack = true;
  # Bun standalone executables store the bundled application in data appended
  # to the ELF. Stripping the executable removes that payload and leaves a bare
  # Bun runtime.
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    gzip -dc $src > $out/bin/gloomberb
    chmod +x $out/bin/gloomberb

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    HOME=$TMPDIR $out/bin/gloomberb --help | grep -F 'gloomberb v${version}'

    runHook postInstallCheck
  '';

  meta = {
    description = "Open-source finance terminal";
    homepage = "https://github.com/gloom-sh/gloomberb";
    changelog = "https://github.com/gloom-sh/gloomberb/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teto ];
    mainProgram = "gloomberb";
    platforms = builtins.attrNames sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
