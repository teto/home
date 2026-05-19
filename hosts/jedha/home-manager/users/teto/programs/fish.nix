{
  functions = {

    llama-jedha = {

      # jinja should be the default ?
      body = "llama-server --host 0.0.0.0 --port 8080 --jinja -v --log-prefix --models-preset ~/home/contrib/llama-presets.ini";
      description = "Run a custom llama-server";
    };

  };

}
