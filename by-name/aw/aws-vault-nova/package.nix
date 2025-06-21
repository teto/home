{ aws-vault, makeWrapper }:

aws-vault.overrideAttrs (oa: {

  nativeBuildInputs = (oa.nativeBuildInputs or [ ]) ++ [
    makeWrapper
  ];

  # --suffix PATH : ${lib.makeBinPath [ bashInteractive xdg-utils ]}"}
  postFixup = ''
    wrapProgram $out/bin/aws-vault \
      --set AWS_VAULT_PASS_PREFIX aws-vault-nova \
      --set AWS_VAULT_BACKEND "pass";
  '';

})
