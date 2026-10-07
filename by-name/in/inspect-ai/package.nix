{
  lib,
  fetchPypi,
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

  # The PyPI source release includes the prebuilt Inspect View frontend.
  src = fetchPypi {
    pname = "inspect_ai";
    inherit version;
    hash = "sha256-PpsBIB1KSDgpv00JKzuGZbxBCCWKyL0EPE+gkPBnNJw=";
  };

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

  # Upstream does not include its test suite in the source release.
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
