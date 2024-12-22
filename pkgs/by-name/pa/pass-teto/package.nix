{ pass, ... }:
let 
  passEnv= (pass.override { waylandSupport = true; }).withExtensions (
  ext: with ext; [
    pass-import
    # TODO pass-tail is an out-of-tree extension I packaged but haven't exposed yet
    # as a pass extension
    # pass-tail 
    pass-otp
  ]
  );
  in passEnv.overrideAttrs({
    name = "pass-teto";
  })
