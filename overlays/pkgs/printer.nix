{
  stdenv,
  fetchurl,
  makeWrapper,
  cups,
  dpkg,
  a2ps,
  ghostscript,
  gnugrep,
  gnused,
  coreutils,
  file,
  perl,
  which,
  lib,
}:

stdenv.mkDerivation rec {
  name = "hll2360dw-cups-${version}";
  version = "3.2.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf101916/hll2360dlpr-3.2.0-1.i386.deb";
    sha256 = "a468b1d53114b1f6580d41ed2aa4b1be72dad4eadce4f017d37a4e36a9ecaf38";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    cups
    ghostscript
    dpkg
    a2ps
  ];

  unpackPhase = ":";

  installPhase = ''
       dpkg-deb -x $src $out

       substituteInPlace $out/opt/brother/Printers/HLL2360DW/cupswrapper/brother-HLL2360DW-cups-en.ppd \
         --replace '"Brother HLL2360DW' '"Brother HLL2360DW (modified)'

       substituteInPlace $out/opt/brother/Printers/HLL2360DW/lpd/lpdfilter \
         --replace /opt "$out/opt" \
         --replace /usr/bin/perl ${perl}/bin/perl \
         --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$out\"; #" \
         --replace "PRINTER =~" "PRINTER = \"HLL2360DW\"; #"

       # FIXME : Allow i686 and armv7l variations to be setup instead.
       _PLAT=x86_64
       patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
         $out/opt/brother/Printers/HLL2360DW/lpd/$_PLAT/brprintconflsr3
       patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
         $out/opt/brother/Printers/HLL2360DW/lpd/$_PLAT/rawtobr3
       ln -s $out/opt/brother/Printers/HLL2360DW/lpd/$_PLAT/brprintconflsr3 $out/opt/brother/Printers/HLL2360DW/lpd/brprintconflsr3
       ln -s $out/opt/brother/Printers/HLL2360DW/lpd/$_PLAT/rawtobr3 $out/opt/brother/Printers/HLL2360DW/lpd/rawtobr3

       for f in \
         $out/opt/brother/Printers/HLL2360DW/cupswrapper/lpdwrapper \
         $out/opt/brother/Printers/HLL2360DW/cupswrapper/paperconfigml2 \
       ; do
         #substituteInPlace $f \
         wrapProgram $f \
           --prefix PATH : ${
             lib.makeBinPath [
               coreutils
               ghostscript
               gnugrep
               gnused
             ]
           }
       done

       # Hack suggested by samueldr.
    #   sed -i"" "s;A4;Letter;g" $out/opt/brother/Printers/HLL2360DW/inf/brHLL2360DWrc

       mkdir -p $out/lib/cups/filter/
       ln -s $out/opt/brother/Printers/HLL2360DW/lpd/lpdfilter $out/lib/cups/filter/brother_lpdwrapper_HLL2390DW

       mkdir -p $out/share/cups/model
       ln -s $out/opt/brother/Printers/HLL2360DW/cupswrapper/brother-HLL2360DW-cups-en.ppd $out/share/cups/model/

       wrapProgram $out/opt/brother/Printers/HLL2360DW/lpd/lpdfilter \
         --prefix PATH ":" ${
           lib.makeBinPath [
             ghostscript
             a2ps
             file
             gnused
             gnugrep
             coreutils
             which
           ]
         }
  '';

  meta = with lib; {
    homepage = "https://www.brother.com/";
    description = "Brother HL-L2360DW combined print driver";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
