{
  functions = {

    llama-jedha = {

      # jinja should be the default ?
      body = "llama-server --host 0.0.0.0 --port 8080 -v --models-preset ~/home/contrib/llama-presets.ini";
      description = "Run llama-server with my presets";
    };

  };

}
