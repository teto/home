let
  myPythonEnv = pkgs.python37.withPackages(ps: with ps; [
    boto3
  ]);

  pkgs = import (fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/c59ea8b8a0e7f927e7291c14ea6cd1bd3a16ff38.tar.gz";
    sha256 = "1ak7jqx94fjhc68xh1lh35kh3w3ndbadprrb762qgvcfb8351x8v";
  }) {};

  # last nixpkgs with kubernetes-helm 2.15
  old = import (fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/de121909d21d7b39ae76a27365e1928f538b7d88.tar.gz";
    sha256 = "0q9l8fx93k62xj7afbp6y1222s9dkswf66b78gl6pd3pngpqs6hp";
  }) {};


# TODO need to

in
pkgs.mkShell {

  name = "platform";
  buildInputs = with pkgs; [
    # black  # python linter
    ansible
    kubectl
    eksctl
    jq
    old.kubernetes-helm
    docker-compose
    myPythonEnv
  ];

  # make gitops
  # ANSIBLE_INVENTORY=./inventories/app-qa
  # ANSIBLE_VAULT_PASSWORD_FILE=.vault/qa
  shellHook = ''
    export ANSIBLE_INVENTORY=./inventories/app-dev-matt
    export ANSIBLE_VAULT_PASSWORD_FILE=.vault/dev
    export ANSIBLE_VAULT_PASSWORD_FILE=.vault/dev
    export ANSIBLE_CONFIG="$HOME/scripts/ansible.cfg"
    export JINKO_GITOPS_DEV_ENVIRONMENT_ID=$USER
    export JINKO_GITOPS_APP_WORKING_DIRECTORY=./tmp

    AWS_PROFILE=default
  '';
}

