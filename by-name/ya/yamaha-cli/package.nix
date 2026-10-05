{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "yamaha-cli";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ljagiello";
    repo = "yamaha-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-AVplVz6NVb3HltYUOTFGLNQgzdsH8KgYdGmjYz6CbJQ=";
  };

  vendorHash = "sha256-KW2TQ1uPkD4FhH1G7Mbpd47QRiPKk5KZ1PiHhM1WwB0=";

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
