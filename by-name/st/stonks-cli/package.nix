{
  lib,
  fetchFromGitHub,
  fetchPypi,
  python3Packages,
}:

let
  pyluach = python3Packages.buildPythonPackage rec {
    pname = "pyluach";
    version = "2.3.0";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-7G4wZp0d9QycoWBIbaRKgZW7THpdPVM5kNDFsDrM0oE=";
    };

    build-system = with python3Packages; [ flit-core ];

    pythonImportsCheck = [ "pyluach" ];
  };

  exchange-calendars = python3Packages.buildPythonPackage rec {
    pname = "exchange-calendars";
    version = "4.13.2";
    pyproject = true;

    src = fetchPypi {
      pname = "exchange_calendars";
      inherit version;
      hash = "sha256-qUWUJd1kFCzVT7xjmEdAPH4MM9YPvDJslPwda9En8AI=";
    };

    build-system = with python3Packages; [
      setuptools
      setuptools-scm
    ];

    dependencies = with python3Packages; [
      korean-lunar-calendar
      numpy
      pandas
      pyluach
      toolz
      tzdata
    ];

    pythonImportsCheck = [ "exchange_calendars" ];
  };
in
python3Packages.buildPythonApplication rec {
  pname = "stonks-cli";
  version = "0.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "igoropaniuk";
    repo = "stonks-cli";
    rev = "v${version}";
    hash = "sha256-DnIkz/r1I7VgZtElerRf7g1EHBeFTglFtOk1/SmL9Mk=";
  };

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    click
    exchange-calendars
    httpx
    openai
    platformdirs
    pyyaml
    rich
    textual
    textual-plotext
    yfinance
  ];

  pythonRelaxDeps = [ "rich" ];

  pythonImportsCheck = [ "stonks_cli" ];

  nativeCheckInputs = with python3Packages; [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # openai 2.41 now rejects the empty API key used to construct ChatScreen.
    "test_action_chat_no_op_when_already_open"
    "test_action_chat_opens_screen"
    "test_on_mount_no_api_key_disables_input"
    "test_stream_response_no_api_key_writes_error"
  ];

  meta = {
    description = "Terminal investment portfolio tracker";
    homepage = "https://github.com/igoropaniuk/stonks-cli";
    changelog = "https://github.com/igoropaniuk/stonks-cli/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teto ];
    mainProgram = "stonks";
  };
}
