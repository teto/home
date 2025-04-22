{
  enable = true;

  settings = {
        daemon = {
          log_level = "info";
          # admin_group = "wheel";
          admin_groups = ["wheel"];

          # This user will have access to the daemon, even if they are not in the part of the `admin_group` group. 
          admin_user = "teto";

          # If set to `true`, this setting makes the LACT daemon not reset
          # GPU clocks when changing other settings or when turning off the daemon.
          disable_clocks_cleanup = false;
          # tcp_listen_address
        };
        apply_settings_timer = 5;
        # gpus = { };
      };
}
