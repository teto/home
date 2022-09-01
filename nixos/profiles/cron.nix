{ config, lib, pkgs, ... }:
let

  /*
   Sync the runner cache with our official cache
  */
  sync2Cache = pkgs.writeShellScriptBin "sync2Cache" ''
    export AWS_SHARED 
    nix copy  --to 's3://devops-ci-infra-prod-caching-nix?region=eu-central-1&profile=nix-daemon'  --all
  '';
in
{
  services.cron.enable = true;
  services.cron.systemCronJobs = [
    # Example of job definition:
    # .---------------- minute (0 - 59)
    # |  .------------- hour (0 - 23)
    # |  |  .---------- day of month (1 - 31)
    # |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
    # |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
    # |  |  |  |  |
    # *  *  *  *  *  user command to be executed

    # TODO shall I
     "0  3  *  *  * ${sync2Cache}"
  ];
}

