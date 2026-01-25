{
  rustPlatform,
  lib,
  pkgs,
}:

rustPlatform.buildRustPackage rec {
  pname = "repeater";
  version = "0.0.26";

  src = pkgs.fetchFromGitHub {
    owner = "shaankhosla";
    repo = "repeater";
    rev = "v${version}";
    sha256 = "sha256-QjT2hljxvRe9XczFNMWV9DKteF6Lob+ix7EnGQ++TyM=";
  };

  cargoHash = "sha256-FlXhiKzDFxvSFTRPtgG93xRpljO/w8jOnZK3wEz1Rjw=";

  nativeBuildInputs = with pkgs; [
    pkg-config
    sqlite
    libsecret
    openssl
    dbus
  ];

  buildInputs = with pkgs; [
    sqlite
    libsecret
    openssl
    dbus
  ];

  meta = with lib; {
    description = "Spaced repetition, in your terminal";
    homepage = "https://github.com/shaankhosla/repeater";
    license = licenses.mit;
    maintainers = with maintainers; [ maintainers.shaankhosla ];
  };
}
