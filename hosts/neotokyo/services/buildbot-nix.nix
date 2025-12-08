{ secrets, pkgs, ...}:
{
  # this is the coordinating node
  # launches systemd.services.buildbot-master
  # clientId = Ov23lifRfN1z1fF5Uw2j for oauth

  master = {
    enable = false;

    # kkind of a cache ?
    niks3 = {
      enable = false;
      package = pkgs.hello;
    };
    domain = "buildbot.${secrets.jakku.hostname}";
    workersFile = pkgs.writeText "workers.json" ''
      [
      ]'';

  github = {
    appId = 2429409;  # The numeric App ID (buildbox-nix-teto = 2429409)
    appSecretKeyFile = "/run/secrets/buildbot-client-secret";  # Path to the downloaded private key

    # MUST BE SET FOR github
    # Optional: Enable OAuth for user login
    # oauthId = "<oauth-client-id>";
    # oauthSecretFile = "/path/to/oauth-secret";

    # I thought it was not used ?
    webhookSecretFile = pkgs.writeText "webhookSecret" "00000000000000000000"; # FIXME: replace this with a secret not stored in the nix store

    # Optional: Filter which repositories to build
    # topic = "buildbot-nix";  # Only build repos with this topic
  };

  # just to fix eval
  #         # { "name": "eve", "pass": "XXXXXXXXXXXXXXXXXXXX", "cores": 16 }
  };

  # TODO setup worker
}
