{


  enable = true;
  enableMcpIntegration = true;
  settings = {
    model_providers.llamacpp = {
      name = "llama.cpp (dev-ia)";
      base_url = "http://dev-ia:9931/v1";
      wire_api = "responses";
      requires_openai_auth = false;
      supports_websockets = false;
    };

    profiles.llamacpp = {
      model = "local-model";
      model_provider = "llamacpp";
    };
  };
  # CODEX_HOME/AGENTS.md.
  # context = "";

  hooks = {
    PreToolUse = [
      {
        matcher = "^Bash$";
        hooks = [
          {
            type = "command";
            # notify
            command = "/usr/local/bin/codex-pre-tool-use";
            timeout = 30;
            statusMessage = "Checking Bash command";
          }

        ];
      }
    ];
  };
}
