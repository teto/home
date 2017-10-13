
{ pkgs
, stdenv, fetchFromGitHub
# , autoreconfHook, libtool, intltool,
, pkgconfig
, sphinx, clang
, withDoc ? false
}:

stdenv.mkDerivation rec {
  name    = "${pname}-${version}";
  pname   = "CastXML";
  # there is no tag, master is considered stable at all times
  version = "20171003";

  src = fetchFromGitHub {
    owner  = "CastXML";
    repo   = "CastXML";
    rev    = "ae62b1a29c8233c3dd40fc3e293ddcdbe0bdcccc";
    sha256 = "1mvn0z1vl4j9drl3dsw2dv0pppqvj29d2m07487dzzi8cbxrqj36";
  };

  # src = /home/teto/CastXML;

  # nativeBuildInputs = 
  propagatedbuildInputs = [ clang ];

  nativeBuildInputs = [ pkgconfig ] ++ stdenv.lib.optionals withDoc [ sphinx ];
  # autoreconfHook libtool


  meta = {
    homepage = http://www.kitware.com;
    license = stdenv.licenses.apache2;
    description = "Abstract syntax tree XML output tool";
    platforms = with stdenv.lib.platforms; unix;
  };
}
