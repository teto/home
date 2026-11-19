# Started as system service
{

  # https://github.com/ggml-org/llama.cpp/blob/master/docs/preset.md:
  # only global section is read from it so we still need models-preset
  environment.etc."llama.cpp/config.ini.template".source = ./spark-presets.ini;

  services.llama-cpp = {
    enable = true;
    openFirewall = true;

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
