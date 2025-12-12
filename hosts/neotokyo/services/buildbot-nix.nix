{ secrets, pkgs, ...}:
let 
  bbSecrets = secrets.jakku.buildbot;
  repoAllowlist = [
      "teto/home"
    ];
in
{
  # this is the coordinating node
  # launches systemd.services.buildbot-master

  master = {
    enable = true;

    # kkind of a cache ?
    niks3 = {
      enable = false;
      package = pkgs.hello;
    };
    domain = "buildbot.${secrets.jakku.hostname}";

    useHTTPS = true;

    # we reduce the number of cores to not overwhelm the server
    workersFile = pkgs.writeText "workers.json" ''
      [
        { "name": "neotokyo", "pass": "${bbSecrets.workerSecret}", "cores": 1 }
      ]'';

      admins = ["teto"];

  github = {
    appId = bbSecrets.appId;  # The numeric App ID 
    appSecretKeyFile = "/run/secrets/buildbot-client-secret";  # Path to the downloaded private key

    # MUST BE SET FOR github
    oauthId = bbSecrets.oauthClientId;
    oauthSecretFile = pkgs.writeText "placeholder-secret" bbSecrets.oauthSecret;

    # I thought it was not used ?
    webhookSecretFile = pkgs.writeText "webhookSecret" bbSecrets.workerSecret;

    # Optional: Filter which repositories to build
    # topic = "buildbot";  # Only build repos with this topic
    topic = null;
    inherit repoAllowlist;
  };

  # just to fix eval
  #         # { "name": "eve", "pass": "XXXXXXXXXXXXXXXXXXXX", "cores": 16 }
  };

  # TODO setup worker
  worker = {
    enable = true;
    name = "neotokyo";
    # number of workers. 0 for a per node
    workers = 1;
    workerPasswordFile = pkgs.writeText "worker-password-file" bbSecrets.workerSecret;
    # The number of workers to start (default: 0 == the number of CPU cores).
    # If you experience flaky builds under high load, try to reduce this value.
    # workers = 0;
  };

}
