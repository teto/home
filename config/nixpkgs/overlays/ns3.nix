self: super:
let
  # fetchgitLocal = super.fetchgitLocal;
in
rec {

  # TODO will loop indefinitely
  ns-3-dev = (super.ns-3.override({
    enableDoxygen = false;
    build_profile = "optimized";
    # withManual = true;
    pythonSupport = true;
    python = super.python3;
    wafHook = super.wafHook.override({python = super.python3;});
  }))
  # .overrideAttrs(old: {
  #   name = "ns3-dev";
  #   src = super.fetchFromGitLab {
  #     owner = "tomhenderson";
  #     repo   = "ns-3-dev";
  #     rev    = "6670ff8d48f69c605d33185febd37d13175599a8";
  #     sha256 = "0xmqq2pkadnspzv509azc93g4f5a3g5snqwhaldiaiidzirk9gwi";
  #   };
  # })
  ;

  ns-3-local = super.ns-3.override {
    python = self.python3;
    enableDoxygen = false;
    build_profile = "optimized";
    # withManual = true;
    # pythonSupport = true;
  #   # withExamples = true;
  };

  ns-3-dce-dev = super.ns-3-dce.overrideAttrs(oa: {
      src = (builtins.fetchGit {
        url  = git://github.com/direct-code-execution/ns-3-dce;
        rev    = "master";
        name = "dce";
      })
  });

  # dce-quagga-dev =  if (super.pkgs ? dce-quagga) then (super.dce-quagga.overrideAttrs( oa: {
  #   srcs = [
  #     (builtins.fetchGit {
  #       url  = git://github.com/direct-code-execution/ns-3-dce;
  #       rev    = "master";
  #       name = "dce";
  #     })
  #     (builtins.fetchGit {
  #       url  = git://github.com/direct-code-execution/ns-3-dce-quagga;
  #       rev    = "master";
  #       name   = "dce-quagga";
  #     })
  #   ];
  # })) else null;

}
