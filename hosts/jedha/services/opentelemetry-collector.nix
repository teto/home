{


  enable = true;

  settings =
let
  port = 4318;
in
    {
          exporters.debug.verbosity = "detailed";
          receivers.otlp.protocols = {
            http.endpoint = "0.0.0.0:${toString port}";
          };
          service = {
            pipelines.logs = {
              receivers = [ "otlp" ];
              exporters = [ "debug" ];
            };
          };

  };
}
