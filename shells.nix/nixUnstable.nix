with import (fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz) {};

nixUnstable.overrideAttrs(o: {
  src = fetchGit https://github.com/NixOS/nix;

  nativeBuildInputs = (o.nativeBuildInputs or []) ++ [
    autoreconfHook autoconf-archive bison flex libxml2 libxslt
    docbook5 docbook5_xsl
  ];

  buildInputs = (o.buildInputs or []) ++ [ boost ];
})
