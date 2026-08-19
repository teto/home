{
  config,
  lib,
  secretsFolder,
  withSecrets,
  ...
}:
lib.optionalAttrs withSecrets {
  wireguard = {
    # tatooine
    id = 2;
    publicKey = "HPrWcZUuJMsxc+qDrN08IC9GJoy/c1UofmvmTC/bm3U=";
    privateKeyFile = "${secretsFolder}/wireguard/${config.networking.hostName}-wg.key";

  };
}
