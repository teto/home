{
  pass,
  fetchFromGitHub,
  passExtensions,
  pass-import-high-password-length,
  # , secretsFolder
  ...
}:
let

  passEnv =
    (pass.override {
      waylandSupport = true;
      # wrapperArgs = [
      #   # "--set PASSWORD_STORE_DIR=${secretsFolder}/password-store"
      # ];
    }).withExtensions
      (ext: [
        pass-import-high-password-length
        # TODO pass-tail is an out-of-tree extension I packaged but haven't exposed yet
        # as a pass extension
        # pass-tail
        ext.pass-otp
        # pass-fzf
      ]);
in
passEnv.overrideAttrs ({
  name = "pass-teto";
})
