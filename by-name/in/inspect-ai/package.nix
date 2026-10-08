{
  lib,
  fetchFromGitHub,
  fetchurl,
  python3Packages,
}:

let
  zipfile-zstd = python3Packages.callPackage ./zipfile-zstd.nix { };
  tokenizerUrl = "https://openaipublic.blob.core.windows.net/encodings/o200k_base.tiktoken";
  tokenizer = fetchurl {
    url = tokenizerUrl;
    hash = "sha256-RGqVOMtsNI41FhINfAiwn1fDZJXirP/+WaW/iwz7Gi0=";
  };
in
python3Packages.buildPythonPackage rec {
  pname = "inspect-ai";
  version = "0.3.277";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "teto";
    repo = "inspect_ai";
    rev = "ba238b00c6da2b61da97577bf839370b1674e847";
    hash = "sha256-OKFzT8fNxKtineTWKRZrTkeuJbmZntgjl79g5CnZTu0=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

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
