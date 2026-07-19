{
  lib,
  fetchFromGitHub,
  perl,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "human-eval";
  version = "unstable-2026-07-19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openai";
    repo = "human-eval";
    rev = "6d43fb980f9fee3c892a914eda09951f772ad10d";
    hash = "sha256-HqClZYzA2i9yio/ljv3EJm8bgw3t6kLTPdKmz5LeFf0=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "import pkg_resources" "" \
      --replace-fail "\"evaluate_functional_correctness = human_eval.evaluate_functional_correctness\"" "\"evaluate_functional_correctness = human_eval.evaluate_functional_correctness:main\""

    perl -0pi -e 's/install_requires=\[\n\s*str\(r\)\n\s*for r in pkg_resources\.parse_requirements\(\n\s*open\(os\.path\.join\(os\.path\.dirname\(__file__\), "requirements\.txt"\)\)\n\s*\)\n\s*\]/install_requires=[line.strip() for line in open(os.path.join(os.path.dirname(__file__), "requirements.txt")) if line.strip()]/s' setup.py
  '';

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  nativeBuildInputs = [
    perl
  ];

  dependencies = with python3Packages; [
    fire
    numpy
    tqdm
  ];

  pythonImportsCheck = [ "human_eval" ];

  # The evaluator is intentionally unsafe unless users explicitly enable the
  # execution call upstream; avoid running generated-code tests in the build.
  doCheck = false;

  meta = {
    description = "Evaluation harness for the HumanEval code generation benchmark";
    homepage = "https://github.com/openai/human-eval";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teto ];
    mainProgram = "evaluate_functional_correctness";
  };
}
