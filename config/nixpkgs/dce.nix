{ pkgs
, stdenv, fetchFromGitHub, autoreconfHook, libtool, intltool, pkgconfig
, ns3, gcc
, withDoc ? false
, withManual ? false
, withExamples ? false
, withTests ? false
, withLibOS ? false
, modules ? [ "core" ]
}:

stdenv.mkDerivation rec {
  name    = "${pname}-${version}";
  pname   = "direct-code-execution";
  version = "1.9";

  # src = fetchFromGitHub {
  #   owner  = "direct-code-execution/";
  #   repo   = "ns-3-dce";
  #   rev    = "${version}";
  #   sha256 = "1mvn0z1vl4j9drl3dsw2dv0pppqvj29d2m07487dzzi8cbxrqj36";
  # };
  src = /home/teto/dce;

  buildInputs = [ ns3 gcc ]
    # ++ stdenv.lib.optionals 
    ;

  nativeBuildInputs = [ pkgconfig ];
  # autoreconfHook libtool

  # with-ns3 should be install folder
  configurePhase = ''
    runHook preConfigure

    # make configure
    # TODO limit modules so that it gets faster
    ./waf configure --prefix=$out \
    --with-ns3=${ns3} \
      ${stdenv.lib.optionalString withExamples "--enable-examples"}
      '' + stdenv.lib.optionalString withTests " --enable-tests \\" + ''

    runHook preConfigure
  '' ;

  # postPatch = ''
  #   sed -i -e 's%"\(/usr/sbin\|/usr/pkg/sbin\|/usr/local/sbin\)/[^"]*",%%g' ./src/nm-l2tp-service.c

  #   substituteInPlace ./src/nm-l2tp-service.c \
  #     --replace /sbin/ipsec  ${strongswan}/bin/ipsec \
  #     --replace /sbin/xl2tpd ${xl2tpd}/bin/xl2tpd
  # '';

  # preConfigure = ''
  #   intltoolize -f
  # '';

  # configureFlags =
  #   if withGnome then "--with-gnome" else "--without-gnome";

  meta = {
    homepage = https://www.nsnam.org/overview/projects/direct-code-execution;
    license = stdenv.lib.licenses.gpl3;
    description = "Run real applications/network stacks in the simulator ns-3";
    platforms = with stdenv.lib.platforms; unix;
  };
}
