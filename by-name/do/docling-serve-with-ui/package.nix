{
  docling-serve,
  docling-serve-ui,
}:
docling-serve.overrideAttrs (old: {
  postInstall = (old.postInstall or "") + ''
    # glob the existing package dir (stdenv uses nullglob, so a glob on the
    # not-yet-existing ui_static would expand to nothing)
    for d in $out/lib/python3*/site-packages/docling_serve; do
      cp -r ${docling-serve-ui} "$d/ui_static"
    done
  '';
})
