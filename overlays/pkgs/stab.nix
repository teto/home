{
  stdenv,
  lib,
  fetchzip,
  pkgconfig,
  libgnome,
  libgnomeui,
  # needs to be python3
  python,

}:

# ifeq ($(HAVE_GNOME_H),1)
# CFLAGS = -g -O4 -Wall -I. `gnome-config --cflags gnome gnomeui`
# LDFLAGS=  `gnome-config --libs gnome gnomeui`
let
  variant = "gtk";
in
stdenv.mkDerivation rec {
  name = "stab-${version}";
  version = "1.3.1";

  src = fetchzip {
    url = "http://www.spin.rice.edu/Software/STAB/stab-1.3.1.tar.gz";
    sha256 = "1z3gychbm95xmqbr4lhcvw3hhkys77c9h3qrfbv358q1w5pdrj3y";
  };
  buildInputs = [
    libgnomeui
    libgnome
    pkgconfig
  ];

  # has no install phase
  installPhase = ''
    mkdir -p $out/bin
    install -D Bin/*/* $out/bin/
  '';

  meta = with lib; {
    description = "Bandwidth probing tool.";
    homepage = "http://www.spin.rice.edu/Software/STAB";
    license = licenses.gpl3;
    maintainers = with maintainers; [ teto ];
  };
}
