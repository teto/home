{ ... }:
{
  # services.tlp = {
  enable = false;
  settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

    CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

    PLATFORM_PROFILE_ON_AC = "performance";
    PLATFORM_PROFILE_ON_BAT = "low-power";

    CPU_BOOST_ON_AC = 1;
    CPU_BOOST_ON_BAT = 0;

    CPU_HWP_DYN_BOOST_ON_AC = 1;
    CPU_HWP_DYN_BOOST_ON_BAT = 0;

    #CPU_MIN_PERF_ON_AC = 0;
    #CPU_MAX_PERF_ON_AC = 100;
    #CPU_MIN_PERF_ON_BAT = 0;
    #CPU_MAX_PERF_ON_BAT = 20;

    #Optional helps save long term battery health
    START_CHARGE_THRESH_BAT0 = 60; # 60 and below it starts to charge
    STOP_CHARGE_THRESH_BAT0 = 90; # 90 and above it stops charging

  };
  # };
}
