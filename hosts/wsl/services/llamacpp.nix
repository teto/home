{
  services.llama-cpp = {
    enable = true;
    # host = "0.0.0.0";
    openFirewall =  true;

    # make sure we have the cuda version
    # package = 

    settings = {
      # models-dir = "/home/teto/llama-models";
# ; only keep  '--models-max' loaded in memory
# models-max = 1;
      models-preset = "${./spark-presets.ini}";

      # batch-size = 512;
      # ctx-size = 252144;
      # flash-attn = "on";
      host = "0.0.0.0";
      # model = "/mnt/llms/Foo3.6-27B-UD-Q4_K_XL.gguf";
      port = 9931;
      # # port = 1337;
      # spec-draft-n-max = 2;
      # spec-type = "draft-mtp";
      # temp = 0.6;
      # top-k = 20;
      # top-p = 0.95;
      # ubatch-size = 256;
      };
  };


}
