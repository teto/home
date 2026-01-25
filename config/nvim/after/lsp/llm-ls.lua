return {
    cmd = { 'llm-ls' },
    cmd_env = {
        LLM_LOG_LEVEL = 'DEBUG',
        HF_TOKEN_PATH = '/home/teto/.config/sops-nix/secrets/huggingfaceToken',
        -- LLM_NVIM_HF_API_TOKEN_
    },
    offset_encoding = 'utf-16',
}
