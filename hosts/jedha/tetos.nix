{
  config,
  withSecrets,
  secretsFolder,
  ...
}:
{
  wireguard = {
    enable = withSecrets;
    # jedha
    id = 3;
    publicKey = "Zr5Q5e2cN6pscnok0z8d30numWMlzud9LE4n0KSSczE=";
    privateKeyFile = "${secretsFolder}/wireguard/${config.networking.hostName}-wg.key";
  };
}
