{
  stdenv,
  lib,
  fetchurl,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation (oa: {
  version = "1.1.0";
  name = "dualsub-${oa.version}";

  jar = fetchurl {
    url = "https://github.com/bonigarcia/dualsub/releases/download/v${oa.version}/${oa.name}.jar";
    sha256 = "0719jpsa5pyw39lk2yybfjpq3jdqpdhl7c4hd32blx40lsfklga1";
  };

  buildInputs = [ makeWrapper ];

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/share/java
    ln -s $jar $out/share/java/${oa.name}.jar
    makeWrapper ${jre}/bin/java $out/bin/dualsub --add-flags "-jar $out/share/java/${oa.name}.jar"
  '';

  meta = {
    description = "A tool which allows you to merge two SRT subtitles in a single file";
    homepage = "https://github.com/bonigarcia/dualsub";
    license = lib.licenses.gpl3;
  };
})
