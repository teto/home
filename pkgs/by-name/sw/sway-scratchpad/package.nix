{
  rustPlatform,
  fetchFromGitHub,
  lib,

  makeWrapper,
  installShellFiles,

}:

rustPlatform.buildRustPackage rec {
  pname = "sway-scratchpad";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "matejc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Ic0vzxby2vJTqdmfDDAYs0TNyntMJuEknbXK3wRjnR4=";
  };

  cargoHash = "sha256-Q+kg1h+kMuni5uhZ1fnHIGbipZ+rdAuyI0Va9ypQuz0=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  # postInstall = with lib;
  # ''
  #     installShellCompletion --cmd yazi \
  #       --bash ./config/completions/yazi.bash \
  #       --fish ./config/completions/yazi.fish \
  #       --zsh  ./config/completions/_yazi
  #   '';

  # passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Convert a command to a scratchpad, and toggle visibility";
    homepage = "https://github.com/matejc/sway-scratchpad";
    license = licenses.bsd2;
    maintainers = with maintainers; [ teto ];
  };
}
