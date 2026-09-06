{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "yamaha-cli";
  version = "0-unstable-2026-08-22";

  src = fetchFromGitHub {
    owner = "ljagiello";
    repo = "yamaha-cli";
    rev = "4905f57ae6368907da643d9f20b74e6a7d9dc8d1";
    hash = "sha256-KVUVT7g5j75q73t4FeVYF29qE+CfBEzC0qMPUCti+9o=";
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
