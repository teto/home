{


  enable = true;
  enableMcpIntegration = true;
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
