self: super:
let
  fetchgitLocal = super.fetchgitLocal;
in
rec {
  # src = fetchFromGitHub {
  #   owner = "gjcarneiro";
  #   repo = "pybindgen";
  #   rev = "ef30ba23dd23afe41aef5bc9aced71c112ccc22e";
  #   sha256 = "1x6paa2r7brmfi4wpx9vvjs64n71k4viy8rq91x9ri0fss1666vj";
  # };

  # src = fetchgit {
  #   url = git://github.com/gjcarneiro/pybindgen;
  #   rev = "ef30ba23dd23afe41aef5bc9aced71c112ccc22e";
  #   sha256 = "02z49igcms4jhrrxjbcwjqlaxx8vsqsmprjr7zmnal3m0v8v45nv";
  #   leaveDotGit = true;
  # };

  # TODO will loop indefinitely
  ns-3-dev = (super.ns-3.override({
    enableDoxygen = false;
    build_profile = "optimized";
    # withManual = true;
    pythonSupport = true;
    python = super.python3;
    wafHook = super.wafHook.override({python = super.python3;});
  })).overrideAttrs(old: {
    name = "ns3-dev";
    src = super.fetchFromGitLab {
      owner = "tomhenderson";
      repo   = "ns-3-dev";
      rev    = "6670ff8d48f69c605d33185febd37d13175599a8";
      sha256 = "0xmqq2pkadnspzv509azc93g4f5a3g5snqwhaldiaiidzirk9gwi";
    };
  });

  ns-3-local = super.ns-3.override {
    python = self.python3;
    enableDoxygen = false;
    build_profile = "optimized";
    # withManual = true;
    # pythonSupport = true;
  #   # withExamples = true;
  };

  # dce = if (super.pkgs ? dce) then super.pkgs.dce else super.callPackage ./pkgs/dce.nix;

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

  # dce-local = (super.dce.override {
  #   python = self.python3;
  #   enableDoxygen = true;
  #   withQuagga  = true;
  #   # withManual = true;
  #   generateBindings = false;
  #   withExamples = true;
  # }).overrideAttrs(old: {
  #   # .lock-waf_linux_build
  #   # { filter, src }
  #   # filter is a function path: type:
  #   # ould keep the current one, but I kn ould keep the current one, but I kn
  #   # builtins.match "^\\.sw[a-z]$" baseName != null ||
  #   src =  super.stdenv.lib.cleanSourceWith { filter= p: t: super.stdenv.lib.cleanSourceFilter p t && baseNameOf p != "build"; src=
  #       (super.stdenv.lib.cleanSourceWith { filter=p: t: baseNameOf p != ".lock-waf_linux_build"; src= /home/teto/dce;});
    
  #     };
    
  # });
}
