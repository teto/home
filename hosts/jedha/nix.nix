{ secretsFolder, ... }:
{

  settings = {

    trusted-public-keys = [
      "${secretsFolder}/nix/tatooine-signing-key.pub"
    ];
  };
}
