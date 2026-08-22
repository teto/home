{
  lib,
  stdenvNoCC,
  darkhttpd,
  fetchFromGitHub,
  fetchNpmDeps,
  makeWrapper,
  nodejs,
  npmHooks,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mokuro-reader";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "Gnathonic";
    repo = "mokuro-reader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+EjKJueJJulH4iMBCHBAfNjM/Fqb3MI00+GU09lRYJs=";
  };

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-YEu8OQZMK+D0JDVZcDnn1bQvGNGRL6xFYnqVIjw9mS8=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    npmHooks.npmConfigHook
  ];

  # Upstream uses adapter-auto for hosted deployments. Use an equivalent
  # dependency-free static adapter so the hash-routed SPA has a deployable
  # index.html in a plain Nix output.
  postPatch = ''
    substituteInPlace svelte.config.js \
      --replace-fail \
        "import adapter from '@sveltejs/adapter-auto';" \
        "const adapter = () => ({ name: 'nix-static', async adapt(builder) { builder.rimraf('build'); builder.writeClient('build'); builder.writePrerendered('build'); await builder.generateFallback('build/index.html'); } });"
  '';

  buildPhase = ''
    runHook preBuild
    npm run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/mokuro-reader"
    cp -r build/. "$out/share/mokuro-reader/"
    makeWrapper ${lib.getExe darkhttpd} "$out/bin/mokuro-reader" \
      --add-flags "$out/share/mokuro-reader" \
      --add-flags "--addr 127.0.0.1" \
      --add-flags "--port 8080"
    runHook postInstall
  '';

  passthru.webRoot = "${finalAttrs.finalPackage}/share/mokuro-reader";

  meta = {
    description = "Web-based manga reader for mokuro-processed manga";
    homepage = "https://github.com/Gnathonic/mokuro-reader";
    changelog = "https://github.com/Gnathonic/mokuro-reader/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ teto ];
    platforms = lib.platforms.all;
    mainProgram = "mokuro-reader";
  };
})
