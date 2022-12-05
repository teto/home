{ config, lib, pkgs, ... }:

{

  # systemd.services.bazel-clean = {
  #   serviceConfig.Type = "oneshot";

  #   script = ''
  #     echo "Cleaning up bazel cache"
  #   '';
  # };


  # systemd.timers.bazel-clean = {
  #   wantedBy = [ "timers.target" ];
  #   partOf = [ "bazel-clean.service" ];
  #   timerConfig = {
  #     # run it every day
  #     OnCalendar = "Wed,Sat *-* 4:00:00";
  #   };
  # };
  # }
}
