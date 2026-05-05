{ secrets, ... }:
{
  services.n8n = {
    enable = false;
    environment = {
      N8N_HOST = "n8n.${secrets.jakku.hostname}";
      N8N_PROTOCOL = "https";
      N8N_LISTEN_ADDRESS = "127.0.0.1";
      WEBHOOK_URL = "https://n8n.${secrets.jakku.hostname}/";
    };
  };
}
