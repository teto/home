{
  config,
  lib,
  pkgs,
  ...
}:
let

  # Sync the runner cache with our official cache
  sync2Cache = pkgs.writeShellScript "sync2Cache" ''
    export AWS_SHARED 
    ${pkgs.nix}/bin/nix copy  --to 's3://devops-ci-infra-prod-caching-nix?region=eu-central-1&profile=nix-daemon'  --all
  '';
in
{
  # services.cron.enable = true;
  # services.cron.systemCronJobs = [
  #   # Example of job definition:
  #   # .---------------- minute (0 - 59)
  #   # |  .------------- hour (0 - 23)
  #   # |  |  .---------- day of month (1 - 31)
  #   # |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
  #   # |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
  #   # |  |  |  |  |
  #   # *  *  *  *  *  user command to be executed

  #   # TODO shall I
  #    "0  3  *  *  * ${sync2Cache}"
  # ];
  # };

  # see `man systemd.timer` for more info
  # Persistent is so that when you schedule the timer for noon but that your laptop is off at this time, it fires as soon as you wake up instead of just skipping
  # https://www.codyhiar.com/blog/repeated-tasks-with-systemd-service-timers-on-nixos/
  systemd.services.cache-update = {
    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = sync2Cache;

    # path = with pkgs; [ systemd system-sendmail ];
  };

  systemd.timers.cache-update = {
    wantedBy = [ "timers.target" ];
    partOf = [ "cache-update.service" ];
    timerConfig = {
      OnUnitInactiveSec = "10m";
    };
  };

  systemd.services.test-timer = {
    script = ''
      echo "hello world"
    '';
    serviceConfig = {
      Type = "oneshot";
      # ExecStart = "${pkgs.coreutils}/bin/true";
    };
  };

  systemd.timers.test-timer = {
    partOf = [ "test-timer.service" ];
    timerConfig = {
      OnCalendar = "minutely";
      # OnUnitInactiveSec = "";

      #   Unit = "cache-update.service";
    };
  };

}
