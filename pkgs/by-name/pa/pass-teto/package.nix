{ pass, ... }:
   (pass.override { waylandSupport = true; }).withExtensions (
    ext: with ext; [
      pass-import
      pass-tail
    ]
  )
