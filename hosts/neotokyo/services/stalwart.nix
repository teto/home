{ config, secrets, withSecrets, ... }:
let
  forwardingAddress = secrets.accounts.mail.fastmail_perso.email;
in
{
  enable = withSecrets && true;
  # shouldn't it inherit it ?
  stateVersion = "26.05";
  openFirewall = true;

  settings = {
    server.hostname = config.networking.fqdn;
    server.listener.smtp = {
      bind = [ "[::]:25" ];
      protocol = "smtp";
      max-connections = 32;
    };

    session.auth = {
      require = false;
      mechanisms = false;
    };

    session.data.limits = {
      messages = 5;
      size = 25 * 1024 * 1024;
    };

    session.rcpt = {
      # Rewrite every envelope recipient before directory and relay checks.
      rewrite = "'${forwardingAddress}'";
      directory = false;
      # Only the fixed destination can be relayed, even if rewriting changes.
      relay = "rcpt == '${forwardingAddress}'";
    };

    # Deliver to Fastmail's published MX servers, with normal MX failover.
    queue.strategy.route = "'mx'";

    queue.limiter.inbound = [
      {
        # Connection attempts per source IP.
        enable = true;
        key = [ "remote_ip" ];
        rate = "30/1m";
      }
      {
        # Bound aggregate connection attempts across all source IPs.
        enable = true;
        key = [ "listener" ];
        rate = "120/1m";
      }
      {
        # Checked at RCPT after rewriting; applies to each message transaction.
        enable = true;
        key = [ "remote_ip" "rcpt" ];
        rate = "60/1h";
      }
      {
        # The rewritten recipient gives a shared limit across all source IPs.
        enable = true;
        key = [ "rcpt" ];
        rate = "300/1h";
      }
    ];

    # No grouping key: share the queue quota across all incoming mail.
    # SMTP returns a temporary failure when full so senders can retry later.
    queue.quota.forwarding = {
      enable = true;
      match = "true";
      messages = 1000;
      size = 1024 * 1024 * 1024;
    };
  };
}
