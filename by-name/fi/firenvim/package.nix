{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  sqlite,
}:
let

  manifest = {
    description = "Firenvim extension host application";
    name = "com.samhh.bukubrow";
    path = "@out@/bin/bukubrow";
    type = "stdio";
  };

in
rustPlatform.buildRustPackage {
  pname = "firenvim";
  version = "0.2.16";

  src = fetchFromGitHub {
    owner = "glacambre";
    repo = "firenvim";
    # ca41ecb5e85313aa3ee350f353536a80604c552d
    # v${version}
    rev = "ca41ecb5e85313aa3ee349f353536a80604c552d";
    sha256 = "1a3gqxj5d1shv3w0v9m7x2xr0bvcynchy778yqalxkc3x4vr0nbn";
  };

  cargoHash = "";

  buildInputs = [ sqlite ];

  passAsFile = [
    "firefoxManifest"
    "chromeManifest"
  ];
  firefoxManifest = builtins.toJSON (manifest // { allowed_extensions = [ "bukubrow@samhh.com" ]; });
  # chromeManifest = builtins.toJSON (manifest // {
  #   allowed_origins = [ "chrome-extension://ghniladkapjacfajiooekgkfopkjblpn/" ];
  # });
  postBuild = ''
    substituteAll $firefoxManifestPath firefox.json
  '';
  postInstall = ''
    install -Dm0644 firefox.json $out/lib/mozilla/native-messaging-hosts/com.samhh.bukubrow.json
  '';

  meta = with lib; {
    description = "Turn Firefox into a Neovim client.";
    homepage = "https://github.com/glacambre/firenvim";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ teto ];
  };
}
