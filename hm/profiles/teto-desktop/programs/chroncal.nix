{

enable = true;
settings = {
        product_id = "-//example//chroncal//EN";
        ui = {
          theme = "default";
          week_start = "monday";
        };
        soft_delete.purge_days = 30;
        sync = {
          interval = "15m";
          conflict_strategy = "prompt";
        };
      };
}
