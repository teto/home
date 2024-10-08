{
  stdenv,
  buildGoPackage,
  fetchFromGitHub,
  lib,
}:

buildGoPackage rec {
  name = "colr-${version}";
  version = "0.3.0";

  goPackagePath = "github.com/k1LoW/colr";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "colr";
    rev = "v${version}";
    sha256 = "1lxawjsaa2ns5xmy7jx0w1yic742vwq7g3rlg3qmwn5ywh9psi5r";
  };

  meta = with lib; {
    homepage = "https://github.com/k1LoW/colr";
    description = "colr colors strings, colorfully.";
    license = [ licenses.mit ];
    maintainers = [ maintainers.teto ];
  };
}
