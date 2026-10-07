# can test RAG, agents from end to end
{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "deepeval";
  version = "4.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "confident-ai";
    repo = "deepeval";
    tag = "python-v${version}";
    hash = "sha256-LzyGKjdW8vtlWigTwPXf4tW8sOHNrMJ6P3dpNKmSFc0=";
  };

  build-system = [ python3Packages.poetry-core ];

  # The pinned nixpkgs provides newer releases than upstream's upper bounds.
  pythonRelaxDeps = [
    "rich"
    "tabulate"
  ];

  dependencies = with python3Packages; [
    aiohttp
    click
    grpcio
    jinja2
    nest-asyncio
    openai
    opentelemetry-api
    opentelemetry-sdk
    portalocker
    posthog
    pydantic
    pydantic-settings
    pyfiglet
    pytest
    pytest-asyncio
    pytest-repeat
    pytest-rerunfailures
    pytest-xdist
    python-dotenv
    questionary
    requests
    rich
    setuptools
    tabulate
    tenacity
    tqdm
    typer
    wheel
  ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  # The full suite needs hosted LLMs, credentials, and optional integrations.
  pytestFlags = [
    "tests/test_core/test_test_case"
    "tests/test_core/test_config/test_settings.py"
  ];

  env.DEEPEVAL_TELEMETRY_OPT_OUT = "1";
  env.DEEPEVAL_DISABLE_DOTENV = "1";

  pythonImportsCheck = [
    "deepeval"
    "deepeval.metrics"
    "deepeval.test_case"
  ];

  meta = {
    description = "Evaluation framework for large language models";
    homepage = "https://github.com/confident-ai/deepeval";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ teto ];
    mainProgram = "deepeval";
  };
}
