{
  enable = false;
  enableMcpIntegration = true;
  settings = {
    model_providers= {
      spark-llama = {
        name = "llama.cpp (dev-ia)";
        base_url = "http://dev-ia:9931/v1";
        wire_api = "responses";
        requires_openai_auth = false;
        supports_websockets = false;
      };
      jedha-llama = {
        name = "llama.cpp (jedha)";
        base_url = "http://llama.jedha.home:9931/v1";
        wire_api = "responses";
        requires_openai_auth = false;
        supports_websockets = false;
      };
    };

  };
  # CODEX_HOME/AGENTS.md.
  # context = "";

  profiles.llamacpp = {
    model = "local-model";
    model_provider = "llamacpp";
  };

  # to avboid prompt
  # hooks = {
  #   PreToolUse = [
  #     {
  #       matcher = "^Bash$";
  #       hooks = [
  #         {
  #           type = "command";
  #           # notify
  #           command = "/usr/local/bin/codex-pre-tool-use";
  #           timeout = 30;
  #           statusMessage = "Checking Bash command";
  #         }
  #
  #       ];
  #     }
  #   ];
  # };
}
