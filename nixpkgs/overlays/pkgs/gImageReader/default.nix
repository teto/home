{ stdenv
, fetchFromGitHub
, cmake
, pkgconfig
, sane-backends # frontends
, podofo
, libjpeg
, djvulibre
, libxmlxx3
, libzip
, tesseract

# , libsForQt5
, withQt ? false
# , poppler
# , quazip
, qtbase ? null
# , qtsvg
# , qtmultimedia
# , qttools

# needs to be python3
, python
, enchant
, intltool

# Gtk deps
, withGtk ? true
, gtk3 ? null
, gtkmm ? null
, pkgs
}:

assert withGtk -> !withQt  && gtk3 != null;
assert withQt  -> !withGtk && qtbase  != null;

let
  variant = if withGtk then "gtk" else if withQt then "qt" else "cli";
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
    pkgs.libuuid
    pkgconfig
    sane-backends
    podofo
    libjpeg
    djvulibre
    pkgs.gobjectIntrospection 
    tesseract
    pkgs.wrapGAppsHook
  ] 
  ++ stdenv.lib.optionals withGtk  ( with pkgs;[
    gnome3.gtkmm
    gtkspell3
    gtkspellmm
    gnome3.gtksourceview
    gnome3.gtksourceviewmm
    cairomm
    poppler.dev
    json-glib
    libxml2
  ])
  ++ stdenv.lib.optionals withQt [
    # qtbase

    # # qtspell # not packaged yetm same author
    # # libsForQt5.
    # poppler  # added 2015-12-19
    # quazip
  ];

  # interface type can be where <type> is either gtk, qt5, qt4
  # "-DCMAKE_INSTALL_PREFIX=$(out)"
  cmakeFlags = [  "-DINTERFACE_TYPE=${variant}" ];
  # configurePhase = "cmake .";

  meta = with stdenv.lib; {
    description = "A collaborative drawing program that allows multiple users to sketch on the same canvas simultaneously";
    homepage = https://github.com/manisandro/gImageReader;
    license = licenses.gpl3;
    maintainers = with maintainers; [teto];
  };
}


