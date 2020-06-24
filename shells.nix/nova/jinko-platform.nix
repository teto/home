with import <nixpkgs> {};

let
  # black
  myPythonEnv = python37.withPackages(ps: with ps; [
    chardet  # encoding detector
    certifi
    locustio  # disable checks for now

    pandas
  ]);

  old = import (builtins.fetchTarball {
      name = "before-libc-update";
      url = "https://github.com/nixos/nixpkgs/archive/a9f721892850913699af0d65883f3b16f18d74bb.tar.gz";
      sha256 = "1bk38vvximyi2li1va8s5sc6akvc3vn0ilcnlbbrxay3chrs1pvp";
  }) {};

in
mkShell {

  name = "platform";
  buildInputs = [
    black  # python linter
    jq
    old.docker-compose
    myPythonEnv
    pipenv

    python-language-server

    # for testing
    httperf
    apacheHttpd  # ab binary
  ];

  #     export DOCKER_HOST=
  shellHook = ''
    export PYTHONPATH=${myPythonEnv}/${myPythonEnv.sitePackages}
  '';
}
