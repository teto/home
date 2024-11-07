{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [

    # openai-whisper is the openai official one
    openai-whisper-cpp

    # look at nixified-ai
    # ollama # st config.withCuda to enable 
    # llama-gpt machine

    # TODO use in ml-tests
    # python310Packages.litellm https://github.com/BerriAI/litellm
  ];

}
