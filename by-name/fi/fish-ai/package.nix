{
  lib,
  fetchFromGitHub,
  fetchPypi,
  python3Packages,
}:

let
  aws-bedrock-token-generator = python3Packages.buildPythonPackage rec {
    pname = "aws-bedrock-token-generator";
    version = "1.1.0";
    pyproject = true;

    src = fetchPypi {
      pname = "aws_bedrock_token_generator";
      inherit version;
      hash = "sha256-lcywf2OpGsSGVh9t8FzE4EeEyP9QhtxoftnF/Tqxtbo=";
    };

    build-system = with python3Packages; [
      setuptools
      setuptools-scm
    ];
    dependencies = with python3Packages; [ botocore ];

    pythonImportsCheck = [ "aws_bedrock_token_generator" ];
  };
in
python3Packages.buildPythonApplication rec {
  pname = "fish-ai";
  version = "2.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Realiserad";
    repo = "fish-ai";
    rev = "v${version}";
    hash = "sha256-ZSFoE9/UesA6GVSYyRKAfj7+uw1gTZ/E08zAHPizAAQ=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    anthropic
    aws-bedrock-token-generator
    binaryornot
    boto3
    google-genai
    groq
    httpx
    iterfzf
    keyring
    openai
    pysocks
    simple-term-menu
  ];

  pythonRelaxDeps = [
    "anthropic"
    "binaryornot"
    "boto3"
    "google-genai"
    "groq"
    "openai"
  ];

  postInstall = ''
    install -Dm644 conf.d/fish_ai.fish \
      $out/share/fish/vendor_conf.d/fish_ai.fish
    substituteInPlace $out/share/fish/vendor_conf.d/fish_ai.fish \
      --replace-fail \
        'set -g _fish_ai_install_dir (test -z "$XDG_DATA_HOME"; and echo "$HOME/.local/share/fish-ai"; or echo "$XDG_DATA_HOME/fish-ai")' \
        'set -g _fish_ai_install_dir "'$out'"'

    for function in functions/*.fish; do
      install -Dm644 "$function" \
        "$out/share/fish/vendor_functions.d/$(basename "$function")"
    done
  '';

  pythonImportsCheck = [ "fish_ai" ];

  meta = {
    description = "AI-powered shell scripting assistance for Fish";
    homepage = "https://github.com/Realiserad/fish-ai";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teto ];
    platforms = lib.platforms.unix;
  };
}
