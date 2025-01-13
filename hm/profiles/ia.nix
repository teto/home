{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [

    # openai-whisper is the openai official one
    # openai-whisper-cpp

    # look at nixified-ai
    # llama-gpt machine
  ];

}
