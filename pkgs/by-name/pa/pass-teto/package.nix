{ pass
# , secretsFolder
, ... }:
let 
  passEnv= (pass.override { 
    waylandSupport = true; 
    wrapperArgs = [
      # "--set PASSWORD_STORE_DIR=${secretsFolder}/password-store"
    ];
  }).withExtensions (
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
