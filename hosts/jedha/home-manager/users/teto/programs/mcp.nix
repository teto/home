{ pkgs, lib, ... }:
{


  enable = true;

  # github:utensils/mcp-nixos
  servers = 
               {

                 nixos = {
                   command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
                 };

                 # https://github.com/homeassistant-ai/ha-mcp
                 ha-mcp = {

                   command = "${lib.getExe pkgs.ha-mcp}";

                 };

               # everything = {
               #   command = "npx";
               #   args = [ "-y" "@modelcontextprotocol/server-everything" ];
               # };
               # context7 = {
               #   url = "https://mcp.context7.com/mcp";
               #   headers.CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
               # };
               # codeberg = {
               #   command = "/path/to/forgejo-mcp";
               #   args = [ "transport" "stdio" "--url" "https://codeberg.org" ];
               #   env.FORGEJO_ACCESS_TOKEN.file = "/run/secrets/codeberg_token";
               # };
             };
}
