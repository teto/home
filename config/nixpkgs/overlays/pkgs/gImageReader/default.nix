{ stdenv , fetchFromGitHub, cmake , pkgconfig, libuuid
, sane-backends, podofo, libjpeg, djvulibre, libxmlxx3, libzip, tesseract
, enchant, intltool, poppler, json-glib
# needs to be python3
, python

# Gtk deps
, gtk3, gobjectIntrospection, wrapGAppsHook
, gnome3, gtkspell3, gtkspellmm, cairomm
}:

let
  variant = "gtk";
  pythonEnv = python.withPackages( ps: with ps;[ pygobject3 ] );
in
stdenv.mkDerivation rec {
  name = "gImageReader-${version}";
  version = "3.2.99";

  src = fetchFromGitHub {
    owner= "manisandro";
    repo = "gImageReader";
    rev = "v${version}";
    sha256 = "19dbxq83j77lbvi10a8x0xxgw5hbsqyc852c196zzvmwk3km6pnc";
  };
  buildInputs = [
    pythonEnv
    cmake
    enchant
    intltool
    libxmlxx3
    libzip
    libuuid
    pkgconfig
    sane-backends
    podofo
    libjpeg
    djvulibre
    tesseract
    poppler.dev
  ] 
  # Gtk specific packets
  ++ [

    gobjectIntrospection 
    gnome3.gtkmm
    gtkspell3
    gtkspellmm
    gnome3.gtksourceview
    gnome3.gtksourceviewmm
    cairomm
    json-glib
  ];

  # interface type can be where <type> is either gtk, qt5, qt4
  cmakeFlags = [  "-DINTERFACE_TYPE=${variant}" ];

  meta = with stdenv.lib; {
    description = "A simple Gtk/Qt front-end to tesseract-ocr.";
    homepage = https://github.com/manisandro/gImageReader;
    license = licenses.gpl3;
    maintainers = with maintainers; [teto];
  };
}


