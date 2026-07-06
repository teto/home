{ writeShellApplication, sbcl }:

# TODO replace by with build-asdf-syste
writeShellApplication {
  name = "wolli";

  runtimeInputs = [ sbcl ];

  # use python3Packages.wakeonlan instead
  # bin/send-wol.lisp
  text = ''
    sbcl --script ${../../../bin/send-wol.lisp} "$@"
  '';
}
