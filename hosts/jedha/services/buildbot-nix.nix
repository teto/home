{ secrets, withSecrets, ...}:
{
  # this is the coordinating node
  # launches systemd.services.buildbot-master

  master = {
    enable = true;

    domain = "buildbot.${secrets.jakku.hostname}";
  authBackend = "github";
  github = {
    appId = 2429409;  # The numeric App ID
    appSecretKeyFile = "/run/secrets/buildbot-client-secret";  # Path to the downloaded private key

    # MUST BE SET FOR github
    # Optional: Enable OAuth for user login
    oauthId = "<oauth-client-id>";
    oauthSecretFile = "/path/to/oauth-secret";

    # Optional: Filter which repositories to build
    topic = "buildbot-nix";  # Only build repos with this topic
  };
  };

  # TODO setup worker
}
