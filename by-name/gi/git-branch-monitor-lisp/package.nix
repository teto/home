{
  writeShellApplication,
  sbcl,
}:

let
  lisp = sbcl.withPackages (ps: [
    ps.clingon
  ]);
in
writeShellApplication {
  name = "git-branch-monitor-lisp";

  runtimeInputs = [ lisp ];

  text = ''
    exec sbcl \
      --noinform \
      --non-interactive \
      --eval '(require :asdf)' \
      --eval '(asdf:load-system :clingon)' \
      --load ${../../../bin/notify-nixpkgs-advancement.lisp} \
      --eval '(foo:main)' \
      --end-toplevel-options \
      "$@"
  '';
}
