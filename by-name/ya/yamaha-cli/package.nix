{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "yamaha-cli";
  version = "0-unstable-2026-10-04";

  src = fetchFromGitHub {
    owner = "ljagiello";
    repo = "yamaha-cli";
    rev = "ee8f34a62837044b9b63e1436c9264c328dcf91e";
    hash = "sha256-V4Z/6gKM5ZWGPbf+yR5ZKRtdv1lJGa0npi2j1omqh4g=";
  };

  vendorHash = "sha256-X70MY6k1TPrOoVHsZ0jW//zKsJuE3FKqOKGT5W6u06o=";

  subPackages = [ "cmd/yamaha" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd yamaha \
      --bash <($out/bin/yamaha completion bash) \
      --fish <($out/bin/yamaha completion fish) \
      --zsh <($out/bin/yamaha completion zsh)
  '';

  meta = {
    description = "Command-line control for Yamaha YXC/MusicCast AV receivers";
    homepage = "https://github.com/ljagiello/yamaha-cli";
    license = lib.licenses.mit;
    mainProgram = "yamaha";
    platforms = lib.platforms.unix;
  };
}
