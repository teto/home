{ config, lib, pkgs,  ... }:
{

  # for sharedssh access
  services.gvfs.enable = true;

  imports = [
    ./postgresql.nix
  ];


  xdg.desktopEntries = {
      min = { # minimal definition
        exec = "firefox -p nova";
        name = "Firefox for nova";
      };
  };

  nix = {
    binaryCaches = [
      "s3://devops-ci-infra-prod-caching-nix?region=eu-central-1&profile=nix-daemon"
      # "https://jinkoone.cachix.org"
      "https://cache.nixos.org/"
    ];

    binaryCachePublicKeys = [
      # "jinkotwo:04t6bF1/peQlZWVpYPN0BraxIV2pdlN2005Vi0hUvso="
      # "jinkoone.cachix.org-1:s17+hDoQ4hVbQkw/Kt0DpoozX2wB7f+smXZ6LcEzmw0="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

    # envVars = {
    #   AWS_PROFILE="nix-daemon";
    # };
  };


  # the config
    # bash -c "$(curl -sSL https://doctor.novadiscovery.net/install-nix)"
    # Add the credentials to the user environnement
    # cat <<EOF | tee ${HOME}/.config/bazel-remote-env > /dev/null
    # export BAZEL_REMOTE_S3_ACCESS_KEY_ID="${JINKO_S3_BAZELCACHE_ACCESS_KEY_ID}"
    # export BAZEL_REMOTE_S3_SECRET_ACCESS_KEY="${JINKO_S3_BAZELCACHE_SECRET_ACCESS_KEY}"
    # EOF
}
