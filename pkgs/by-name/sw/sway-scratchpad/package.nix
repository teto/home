{ rustPlatform
, fetchFromGitHub
, lib

, makeWrapper
, installShellFiles
, stdenv

}:

rustPlatform.buildRustPackage rec {
  pname = "sway-scratchpad";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "matejc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TgiwU95BbKFvISDe8+wn8VQ+8vQNuGsb+7p9kP//5lw=";
  };

  cargoHash = "sha256-VLWjpb9OmYkBykP51YURWnvgzI1DW0731DbDcJh/7h8=";

  nativeBuildInputs = [ makeWrapper installShellFiles ];

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
    maintainers = with maintainers; [teto];
  };
}
