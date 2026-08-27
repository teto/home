{ config, ... }:
{
  enable = false;
  environment = {
    N8N_HOST = "127.0.0.1";
    N8N_PROTOCOL = "https";
    N8N_LISTEN_ADDRESS = "127.0.0.1";
    # .local / .vpn
    WEBHOOK_URL = "https://n8n.${config.networking.hostName}";
  };

}
