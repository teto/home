# TODO pin
with import <nixpkgs> {};

let

  myPythonEnv = poetry2nix.mkPoetryEnv {
    projectDir = ./.;
  };

  # myPythonEnv = python37.withPackages(ps: with ps; [
  #   chardet  # encoding detector
  #   certifi
  #   locustio  # disable checks for now / locustio not supported for 3.8
  #   pandas
  #   poetry  # temp to test
  # ]);

in
mkShell {

  name = "platform";
  buildInputs = [
    black  # python linter
    jq
    docker-compose
    myPythonEnv
    pipenv

    python-language-server

    # for testing
    httperf
    apacheHttpd  # ab binary
  ];

  shellHook = ''
    export PYTHONPATH=${myPythonEnv}/${myPythonEnv.sitePackages}
    # Use Docker Buildkit
    export COMPOSE_DOCKER_CLI_BUILD=1
    export DOCKER_BUILDKIT=1


  '';
}
