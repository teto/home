{ config, ... }:
{
  sleep.extraConfig = ''
    HibernateDelaySec=30m
    SuspendState=mem
  '';

  # This environment variable prevents the AWS cli from trying to fetch
  # metadata at the initialisation, and allow us to win 6 seconds of
  # waiting at each nix command.
  # See https://github.com/aws/aws-cli/issues/5623
  services.nix-daemon.serviceConfig.Environment = [ "AWS_EC2_METADATA_DISABLED=true" ];
}
