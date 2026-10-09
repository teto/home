{
  lib,
  fetchFromGitHub,
  fetchurl,
  python3Packages,
}:

let
  # These run inside the target sandbox, whose architecture/libc may differ
  # from the host. Keep their bytes intact for upstream digest verification.
  sandboxTools =
    lib.mapAttrsToList
      (
        name: hash:
        fetchurl {
          inherit name hash;
          url = "https://inspect-sandbox-tools.s3.us-east-2.amazonaws.com/${name}";
        }
      )
      {
        inspect-sandbox-tools-amd64-v33 = "sha256-1Bss05VfDG7IqlCw8uM+hF2/tEdQx/wZKgAqNBmYq8M=";
        inspect-sandbox-tools-amd64-musl-v33 = "sha256-DhteF25Ro8ZfkqQU7rWXaZlUncSSJr7TS0Pu4Nq8lWs=";
        inspect-sandbox-tools-arm64-v33 = "sha256-PFRTasadvfkA53uH9ccDCqdrrextGi9lk/cmvwwaZIM=";
        inspect-sandbox-tools-arm64-musl-v33 = "sha256-jS8RyRjoVAmldewH7bRUh9EOl9tgFD7WwKA+rg+ZvWo=";
      };
  zipfile-zstd = python3Packages.callPackage ./zipfile-zstd.nix { };
  tokenizerUrl = "https://openaipublic.blob.core.windows.net/encodings/o200k_base.tiktoken";
  tokenizer = fetchurl {
    url = tokenizerUrl;
    hash = "sha256-RGqVOMtsNI41FhINfAiwn1fDZJXirP/+WaW/iwz7Gi0=";
  };
in
python3Packages.buildPythonPackage rec {
  pname = "inspect-ai";
  version = "0.3.277-unstable-2026-10-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "teto";
    repo = "inspect_ai";
    # teto/fixes
    rev = "f7ab982a0f0a0aa1e0da4269fa10d0df4804acf7";
    hash = "sha256-k344jcf5DQo9Z73I84fsZgo6fI2+L9EMML7oVZzCdug=";
  };

  # Python package metadata requires a PEP 440 version.
  env.SETUPTOOLS_SCM_PRETEND_VERSION = lib.replaceStrings [ "-unstable-" "-" ] [ ".dev" "" ] version;

  postPatch = ''
    mkdir -p src/inspect_ai/binaries
    ${lib.concatMapStringsSep "\n" (binary: ''
      install -m755 ${binary} src/inspect_ai/binaries/${binary.name}
    '') sandboxTools}
    (cd src/inspect_ai/binaries && sha256sum -c ../tool/_sandbox_tools_utils/SHA256SUMS)
  '';

  dontStrip = true;

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies =
    with python3Packages;
    [
      agent-client-protocol
      aiobotocore
      anyio
      beautifulsoup4
      boto3
      click
      debugpy
      docstring-parser
      fastapi
      fsspec
      httpx
      ijson
      jsonlines
      jsonpatch
      jsonpath-ng
      jsonref
      jsonschema
      markdown-it-py
      mmh3
      nest-asyncio2
      numpy
      platformdirs
      psutil
      pydantic
      python-dotenv
      pyyaml
      rich
      s3fs
      semver
      shortuuid
      sniffio
      tenacity
      textual
      tiktoken
      typing-extensions
      universal-pathlib
      uvicorn
      zipp
      zstandard
    ]
    ++ lib.optional (python3Packages.pythonOlder "3.14") zipfile-zstd;

  # Exercise evaluation, scoring, log serialization, and the packaged viewer.
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    export XDG_DATA_HOME="$TMPDIR/inspect-data"
    export XDG_CACHE_HOME="$TMPDIR/inspect-cache"
    export INSPECT_EVAL_CTL_SERVER=false
    export TIKTOKEN_CACHE_DIR="$TMPDIR/tiktoken-cache"
    mkdir -p "$TIKTOKEN_CACHE_DIR"
    cp ${tokenizer} "$TIKTOKEN_CACHE_DIR/${builtins.hashString "sha1" tokenizerUrl}"
    PYTHONPATH="$out/${python3Packages.python.sitePackages}:$PYTHONPATH" \
      python ${./smoke-test.py}
    "$out/bin/inspect" --version
    "$out/bin/inspect" eval --help > /dev/null
    runHook postInstallCheck
  '';

  pythonImportsCheck = [
    "inspect_ai"
    "inspect_ai.agent"
    "inspect_ai.model"
    "inspect_ai.scorer"
    "inspect_ai.tool"
  ];

  meta = {
    description = "Framework for large language model evaluations";
    homepage = "https://inspect.aisi.org.uk/";
    changelog = "https://github.com/UKGovernmentBEIS/inspect_ai/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teto ];
    mainProgram = "inspect";
  };
}
