{
  lib,
  fetchFromGitHub,
  git,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "tool-eval-bench";
  version = "2.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SeraphimSerapis";
    repo = "tool-eval-bench";
    tag = "v${version}";
    hash = "sha256-rkbJDH4cF9tvItRKKSIOUhrJUyIB1NjW2VpWwenT9mM=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
    wheel
  ];

  # Release archives do not include the Git metadata used by setuptools-scm.
  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  dependencies = with python3Packages; [
    httpx
    python-dotenv
    pyyaml
    rich
  ];

  nativeCheckInputs = with python3Packages; [
    git
    pytestCheckHook
    pytest-asyncio
  ];

  # Release archives do not contain the Git index inspected by this test.
  disabledTests = [ "test_lockfile_is_tracked_and_not_ignored" ];

  # Upstream's pytest configuration excludes tests requiring a live endpoint.
  pythonImportsCheck = [ "tool_eval_bench" ];

  meta = {
    description = "Tool-calling quality benchmark for LLM serving stacks";
    homepage = "https://github.com/SeraphimSerapis/tool-eval-bench";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teto ];
    mainProgram = "tool-eval-bench";
  };
}
