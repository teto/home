final: prev:
rec {

  # TODO will loop indefinitely
  ns-3-dev = (prev.ns-3.override({
    enableDoxygen = false;
    build_profile = "optimized";
    # withManual = true;
    pythonSupport = false;
    python = prev.python3;
    # wafHook = prev.wafHook.override({python = prev.python3;});
  }))

  # .overrideAttrs(old: {
  #   name = "ns3-dev";
  #   src = prev.fetchFromGitLab {
  #     owner = "tomhenderson";
  #     repo   = "ns-3-dev";
  #     rev    = "6670ff8d48f69c605d33185febd37d13175599a8";
  #     sha256 = "0xmqq2pkadnspzv509azc93g4f5a3g5snqwhaldiaiidzirk9gwi";
  #   };
  # })
  ;

  # dce-quagga-dev =  if (prev.pkgs ? dce-quagga) then (prev.dce-quagga.overrideAttrs( oa: {
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
