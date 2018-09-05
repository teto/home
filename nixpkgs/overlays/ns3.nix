self: super:
let
  fetchgitLocal = super.fetchgitLocal;
in
rec {

  # TODO will loop indefinitely
  # ns3-dev = super.ns-3.overrideAttrs(old: {
  #   name = "ns3-dev";
  #   src = builtins.fetchGit 
  #   # super.fetchFromGitHub 
  #   {
  #     url = git://github.com/nsnam/ns-3-dev-git;
  #     rev    = "75f6501d4dbbb57ecc0a3907c8428f8ffafb96bd";
  #     # sha256 = "1qdyrpdn9d5ii9ihvw38nidln7mgnsxwfz2gyl44cgj32syi9m8x";
  #   };
  # });

  ns3-local = super.ns-3.override {
    python = self.python3;
    enableDoxygen = false;
    build_profile = "optimized";
    # withManual = true;
    generateBindings = true;
  #   # withExamples = true;
  };

  dce-quagga-dev =  if (super.pkgs ? dce-quagga) then (super.dce-quagga.overrideAttrs( oa: {
    srcs = [
      (builtins.fetchGit {
        url  = git://github.com/direct-code-execution/ns-3-dce;
        rev    = "master";
        name = "dce";
      })
      (builtins.fetchGit {
        url  = git://github.com/direct-code-execution/ns-3-dce-quagga;
        rev    = "master";
        name   = "dce-quagga";
      })
    ];

  })) else null;

  dce-local = if (super.pkgs ? dce) then (super.dce.override {
    python = self.python3;
    enableDoxygen = true;
    # withManual = true;
    generateBindings = true;
    withExamples = true;
  }).overrideAttrs(old: {
    # .lock-waf_linux_build
    # { filter, src }
    # filter is a function path: type:
    # ould keep the current one, but I kn ould keep the current one, but I kn
    # builtins.match "^\\.sw[a-z]$" baseName != null ||
    src =  super.stdenv.lib.cleanSourceWith { filter= p: t: super.stdenv.lib.cleanSourceFilter p t && baseNameOf p != "build"; src=
        (super.stdenv.lib.cleanSourceWith { filter=p: t: baseNameOf p != ".lock-waf_linux_build"; src= /home/teto/dce;});
    
      };
    
  }) else null;
}
